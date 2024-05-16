# Data Persistence and Management System

This repository provides a comprehensive data persistence and management system using Swift, Combine, and SwiftUI. It facilitates efficient data handling, including storage, retrieval, and synchronization across different layers of an application. This README explains the system's components, their usage, and integration guidelines.

## Table of Contents

1. [Overview](#overview)
2. [ModelType Enum](#modeltype-enum)
3. [DataStore](#datastore)
4. [ModelContext](#modelcontext)
5. [PersistenceManager](#persistencemanager)
6. [ServicesDataManager](#servicesdatamanager)
7. [DependencyServiceDataContainer](#dependencyservicedatacontainer)
8. [ModelContainer](#modelcontainer)
9. [DataStore Protocol](#datastore-protocol)
10. [DataManager](#datamanager)
11. [Query Struct](#query-struct)
12. [Aggregation Enum](#aggregation-enum)
13. [Join Struct](#join-struct)
14. [JoinType Enum](#jointype-enum)
15. [CustomExpression Struct](#customexpression-struct)
16. [Practical Usage Examples](#practical-usage-examples)

## Overview

This system is designed to manage data models effectively, offering functionalities for CRUD operations, data persistence, and synchronization across different parts of the application.

### Key Components

- **ModelType Enum**: Defines different model types.
- **DataStore**: Manages models in memory and publishes updates.
- **ModelContext**: Handles model-specific operations with autosave capability.
- **PersistenceManager**: Manages permanent storage of data.
- **ServicesDataManager**: Centralizes data management services.
- **DependencyServiceDataContainer**: Provides access to different data managers.
- **ModelContainer**: Handles generic entity operations and persistence.
- **DataStore Protocol**: Defines the contract for data store operations.
- **DataManager**: Manages entities and synchronizes with data stores.
- **Query Struct**: Defines querying mechanisms with predicates, sorting, and more.
- **Aggregation Enum**: Defines aggregation functions for queries.
- **Join Struct**: Represents join operations between data models.
- **JoinType Enum**: Enumerates different types of join operations.
- **CustomExpression Struct**: Allows custom expressions in queries.

## ModelType Enum

The `ModelType` enum defines different model types and provides a method to check if a given type matches the model type.

```swift
enum ModelType {
    case user

    // Checks if the model type matches the given type
    func isModelType(_ type: (some Any).Type) -> Bool {
        switch self {
        case .user:
            return type == UserModel.self
        }
    }
}
```

## DataStore

The `DataStore` class is a singleton that manages different models in memory and publishes updates to subscribers. It provides methods for inserting, updating, and retrieving models.

### Initialization

The `DataStore` is initialized as a singleton instance to ensure there is only one instance managing the data.

```swift
final class DataStore: ObservableObject {
    static let shared = DataStore()
    private(set) var models: [ModelType: AnyObject] = [:]
    private var modelsSubject = PassthroughSubject<Void, Never>()
    private let dataStoreQueue = DispatchQueue(label: "dataStoreQueue", attributes: .concurrent)

    private init() {}
}
```

### Publishing Changes

The `modelsPublisher` property allows subscribers to listen for changes in the models.

```swift
var modelsPublisher: AnyPublisher<Void, Never> {
    modelsSubject.eraseToAnyPublisher()
}
```

### Upsert Method

The `upsert` method updates or inserts a model. It ensures type safety by checking if the model type matches the expected type.

```swift
func upsert<T: Identifiable & Codable>(_ modelType: ModelType, model: T, allowCreation: Bool = true) {
    guard modelType.isModelType(T.self) else {
        print("Error: Model type mismatch.")
        return
    }

    dataStoreQueue.async(flags: .barrier) {
        if let existingObject = self.models[modelType] as? T {
            let updatedObject = self.merge(existingObject, with: model)
            self.setObject(updatedObject, for: modelType)
        } else if allowCreation {
            self.setObject(model, for: modelType)
        } else {
            print("Object of type \(modelType) does not exist and creation is not allowed.")
        }
    }
}
```

### Merge Method

The `merge` method combines an existing object with new data.

```swift
private func merge<T: Identifiable & Codable>(_ oldObject: T, with newObject: T) -> T {
    let newMirror = Mirror(reflecting: newObject)
    let updatedObject = (oldObject as AnyObject).mutableCopy() as! T

    for (key, newValue) in newMirror.children {
        if let key {
            let selector = Selector("\(key)")
            if (updatedObject as AnyObject).responds(to: selector) {
                (updatedObject as AnyObject).setValue(newValue, forKey: key)
            }
        }
    }

    return updatedObject
}
```

### Set Object Method

The `setObject` method sets an object in the data store.

```swift
private func setObject(_ object: some Identifiable & Codable, for modelType: ModelType) {
    dataStoreQueue.async(flags: .barrier) {
        self.models[modelType] = object as AnyObject
        DispatchQueue.main.async {
            self.modelsSubject.send()
        }
    }
}
```

### Get Object Method

The `getObject` method retrieves an object from the data store.

```swift
func getObject<T: Identifiable & Codable>(for modelType: ModelType, as _: T.Type) -> T? {
    var result: T?
    dataStoreQueue.sync {
        result = self.models[modelType] as? T
    }
    return result
}
```

## ModelContext

The `ModelContext` class handles model-specific operations and manages autosaving.

### Initialization

The `ModelContext` is initialized with a `ModelContainer`.

```swift
class ModelContext {
    private var container: ModelContainer
    var autosaveEnabled: Bool = true
    private let updateSubject = PassthroughSubject<Void, Never>()
    private let ioQueue = DispatchQueue(label: "modelContextQueue", attributes: .concurrent)

    var updates: AnyPublisher<Void, Never> {
        updateSubject.eraseToAnyPublisher()
    }

    init(_ container: ModelContainer) {
        self.container = container
    }
}
```

### Model Fetching

The `model` method fetches a model by its ID.

```swift
func model<T: Identifiable & Codable>(for id: String) -> T? where T.ID == String {
    container.fetch(id: id)
}
```

### Save Method

The `save` method saves an entity.

```swift
func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    if autosaveEnabled {
        ioQueue.async(flags: .barrier) {
            do {
                try self.container.save(entity)
                DispatchQueue.main.async {
                    self.notifyUpdates()
                }
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
```

### Update Method

The `update` method updates an entity.

```swift
func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    if autosaveEnabled {
        ioQueue.async(flags: .barrier) {
            do {
                try self.container.update(entity)
                DispatchQueue.main.async {
                    self.notifyUpdates()
                }
            } catch {
                print("Update error: \(error)")
            }
        }
    }
}
```

### Delete Method

The `delete` method deletes an entity.

```swift
func delete<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    if autosaveEnabled {
        ioQueue.async(flags: .barrier) {
            do {
                try self.container.delete(entity: entity)
                DispatchQueue.main.async {
                    self.notifyUpdates()
                }
            } catch {
                print("Delete error: \(error)")
            }
        }
    }
}
```

### Notify Updates

The `notifyUpdates` method publishes updates.

```swift
private func notifyUpdates() {
    updateSubject.send(())
}
```

## PersistenceManager

The `PersistenceManager` class manages the permanent storage of data.

### Save to Permanent Storage

The `saveToPermanentStorage` method saves an entity to permanent storage.

```swift
func saveToPermanentStorage<T: Codable & Identifiable>(_ entity: T) throws where T.ID == String {
    ioQueue.async(flags: .barrier) {
        let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(String(describing: T.self))_\(entity.id).json")
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let existingData = try Data(contentsOf: fileURL)
                var existingEntity = try decoder.decode(T.self, from: existingData)

                let changes = self.mergeEntities(from: &existingEntity, into: entity)

                if changes.is

Empty {
                    print("No changes detected, not writing to file.")
                } else {
                    let newData = try encoder.encode(existingEntity)
                    try newData.write(to: fileURL, options: [.atomicWrite])
                    print("Data written to file: \(fileURL.path)")
                    print("Updated fields: \(changes)")
                    print("Updated entity: \(existingEntity)")
                }
            } catch {
                print("Error reading existing data or merging entities: \(error)")
            }
        } else {
            do {
                let newData = try encoder.encode(entity)
                try newData.write(to: fileURL, options: [.atomicWrite])
                print("Data written to file: \(fileURL.path)")
                print("New entity: \(entity)")
            } catch {
                print("Error writing new data to file: \(error)")
            }
        }
    }
}
```

### Merge Entities

The `mergeEntities` method merges two entities.

```swift
private func mergeEntities<T: Codable>(from oldEntity: inout T, into newEntity: T) -> [String: Any] {
    let encoder = JSONEncoder()

    do {
        let fromData = try encoder.encode(oldEntity)
        let intoData = try encoder.encode(newEntity)
        var fromDict = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String: Any] ?? [:]
        let intoDict = try JSONSerialization.jsonObject(with: intoData, options: []) as? [String: Any] ?? [:]

        var changes: [String: Any] = [:]

        for (key, newValue) in intoDict {
            if let oldValue = fromDict[key], !compareValues(oldValue, newValue) {
                changes[key] = newValue
                fromDict[key] = newValue
            } else if fromDict[key] == nil {
                changes[key] = newValue
                fromDict[key] = newValue
            }
        }

        if !changes.isEmpty {
            let mergedData = try JSONSerialization.data(withJSONObject: fromDict, options: [])
            oldEntity = try JSONDecoder().decode(T.self, from: mergedData)
            print("Updated fields: \(changes)")
        }

        return changes
    } catch {
        print("Error during entity merge: \(error)")
        return [:]
    }
}
```

### Compare Values

The `compareValues` method compares two values.

```swift
private func compareValues(_ oldValue: Any, _ newValue: Any) -> Bool {
    if let oldArray = oldValue as? [Any], let newArray = newValue as? [Any] {
        return oldArray.elementsEqual(newArray, by: { compareValues($0, $1) })
    } else if let oldDict = oldValue as? [String: Any], let newDict = newValue as? [String: Any] {
        return dictionariesEqual(oldDict, newDict)
    } else {
        return "\(oldValue)" == "\(newValue)"
    }
}
```

### Dictionaries Equal

The `dictionariesEqual` method checks if two dictionaries are equal.

```swift
private func dictionariesEqual(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
    guard lhs.count == rhs.count else { return false }

    for (key, lhsValue) in lhs {
        guard let rhsValue = rhs[key] else { return false }
        if !compareValues(lhsValue, rhsValue) {
            return false
        }
    }
    return true
}
```

### Remove from Permanent Storage

The `removeFromPermanentStorage` method removes an entity from permanent storage.

```swift
func removeFromPermanentStorage<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    ioQueue.async(flags: .barrier) {
        let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(String(describing: T.self))_\(entity.id).json")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
}
```

### Get Documents Directory

The `getDocumentsDirectory` method returns the documents directory URL.

```swift
private func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
```

### Delete All Data

The `deleteAllData` method deletes all data.

```swift
func deleteAllData() throws {
    ioQueue.async(flags: .barrier) {
        let fileManager = FileManager.default
        let documentsDirectory = self.getDocumentsDirectory()
        do {
            let files = try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
            for file in files {
                let fileURL = documentsDirectory.appendingPathComponent(file)
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting all data: \(error)")
        }
    }
}
```

## ServicesDataManager

The `ServicesDataManager` class centralizes data management services, providing access to different data managers.

### Initialization

The `ServicesDataManager` initializes with the necessary data managers.

```swift
class ServicesDataManager {
    static let shared = ServicesDataManager()
    let userDataManager: DataManager<UserModel>

    init() {
        self.userDataManager = DependencyServiceDataContainer.shared.userDataManager
    }
}
```

## DependencyServiceDataContainer

The `DependencyServiceDataContainer` class provides access to different data managers.

### Initialization

The `DependencyServiceDataContainer` initializes with the necessary data managers.

```swift
class DependencyServiceDataContainer {
    static let shared = DependencyServiceDataContainer()
    lazy var userDataManager: DataManager<UserModel> = DataManager(dataStore: AnyDataStore(InMemoryDataStore<UserModel>.init()))
}
```

## ModelContainer

The `ModelContainer` class handles generic entity operations and persistence.

### Fetch Method

The `fetch` method retrieves an entity by its ID.

```swift
func fetch<T: Identifiable & Codable>(id: String) -> T? where T.ID == String {
    ioQueue.sync {
        entities[id] as? T
    }
}
```

### Save Method

The `save` method saves an entity.

```swift
func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    ioQueue.async(flags: .barrier) {
        self.entities[entity.id] = entity
        do {
            try self.persistenceManager.saveToPermanentStorage(entity)
        } catch {
            print("Save error: \(error)")
        }
    }
}
```

### Update Method

The `update` method updates an entity.

```swift
func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
    ioQueue.async(flags: .barrier) {
        self.entities[entity.id] = entity
        do {
            try self.persistenceManager.saveToPermanentStorage(entity)
        } catch {
            print("Update error: \(error)")
        }
    }
}
```

### Delete Method

The `delete` method deletes an entity.

```swift
func delete<T: Identifiable & Codable>(entity: T) throws where T.ID == String {
    ioQueue.async(flags: .barrier) {
        self.entities.removeValue(forKey: entity.id)
        do {
            try self.persistenceManager.removeFromPermanentStorage(entity)
        } catch {
            print("Delete error: \(error)")
        }
    }
}
```

### Load All Method

The `loadAll` method loads all entities.

```swift
func loadAll<T: Identifiable & Codable>() -> [T] where T.ID == String {
    ioQueue.sync {
        entities.values.compactMap { $0 as? T }
    }
}
```

### Filter Method

The `filter` method filters entities based on a predicate.

```swift
func filter<T: Identifiable & Codable>(_ predicate: NSPredicate) -> [T] where T.ID == String {
    ioQueue.sync {
        let allEntities = entities.values.compactMap { $0 as? T }
        return (allEntities as NSArray).filtered(using: predicate) as! [T]
    }
}
```

### Execute Query

The `execute` method executes a query.

```swift
func execute<T: Identifiable & Codable>(query: Query<T>) -> [T] where T.ID == String {
    ioQueue.sync {
        var result = loadAll() as [T]
        if let predicate = query.predicate {
            result = filter(predicate)
        }
        if let sortDescriptors = query.sortDescriptors {
            result = (result as NSArray).sortedArray(using: sortDescriptors) as! [T]
        }
        return result
    }
}
```

## DataStore Protocol

The `DataStoreProtocol` defines the contract for data store operations.

### Protocol Definition

```swift
protocol DataStoreProtocol {
    associatedtype Entity: Identifiable & Codable
    var updates: AnyPublisher<Entity, Never> { get }
    func load(completion: @escaping (Result<[Entity], Error>) -> Void)
    func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
    func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
```

### AnyDataStore Class

The `AnyDataStore` class is a type-erased wrapper around any data store that conforms to `DataStoreProtocol`.

```swift
class AnyDataStore<Entity: Identifiable & Codable>: Data

StoreProtocol {
    private var innerLoad: (@escaping (Result<[Entity], Error>) -> Void) -> Void
    private var innerSave: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
    private var innerUpdate: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
    private var innerDelete: (String, @escaping (Result<Void, Error>) -> Void) -> Void
    var updates: AnyPublisher<Entity, Never>

    init<Store: DataStoreProtocol>(_ store: Store) where Store.Entity == Entity {
        self.innerLoad = store.load
        self.innerSave = store.save
        self.innerUpdate = store.update
        self.innerDelete = store.delete
        self.updates = store.updates
    }

    func load(completion: @escaping (Result<[Entity], Error>) -> Void) {
        innerLoad(completion)
    }

    func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
        innerSave(entity, completion)
    }

    func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
        innerUpdate(entity, completion)
    }

    func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        innerDelete(entityId, completion)
    }
}
```

### InMemoryDataStore Class

The `InMemoryDataStore` class is an in-memory implementation of `DataStoreProtocol`.

```swift
class InMemoryDataStore<Entity: Identifiable & Codable>: DataStoreProtocol where Entity.ID == String {
    private var entities: [String: Entity] = [:]
    private let updateSubject = PassthroughSubject<Entity, Never>()

    var updates: AnyPublisher<Entity, Never> {
        updateSubject.eraseToAnyPublisher()
    }

    func load(completion: @escaping (Result<[Entity], Error>) -> Void) {
        completion(.success(Array(entities.values)))
    }

    func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
        entities[entity.id] = entity
        updateSubject.send(entity)
        completion(.success(()))
    }

    func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
        if let _ = entities.updateValue(entity, forKey: entity.id) {
            updateSubject.send(entity)
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "UpdateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
        }
    }

    func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let _ = entities.removeValue(forKey: entityId) {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "DeleteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
        }
    }
}
```

## DataManager

The `DataManager` class manages entities and synchronizes with data stores.

### Initialization

The `DataManager` initializes with a data store.

```swift
class DataManager<Entity: Identifiable & Codable> where Entity.ID == String {
    @Published var entities: [Entity] = []
    private var dataStore: AnyDataStore<Entity>
    private var cancellables: Set<AnyCancellable> = []

    init(dataStore: AnyDataStore<Entity>) {
        self.dataStore = dataStore
        dataStore.updates
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] entity in
                if let index = self?.entities.firstIndex(where: { $0.id == entity.id }) {
                    self?.entities[index] = entity
                } else {
                    self?.entities.append(entity)
                }
            })
            .store(in: &cancellables)

        loadEntities()
    }
}
```

### Load Entities

The `loadEntities` method loads all entities.

```swift
func loadEntities() {
    dataStore.load { [weak self] result in
        DispatchQueue.main.async {
            switch result {
            case let .success(entities):
                self?.entities = entities
            case let .failure(error):
                print("Error loading entities: \(error)")
            }
        }
    }
}
```

### Save Entity

The `saveEntity` method saves an entity.

```swift
func saveEntity(_ entity: Entity) {
    dataStore.save(entity: entity) { result in
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("Entity saved successfully")
            case let .failure(error):
                print("Save error: \(error)")
            }
        }
    }
}
```

### Update Entity

The `updateEntity` method updates an entity.

```swift
func updateEntity(_ entity: Entity) {
    dataStore.update(entity: entity) { result in
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("Entity updated successfully")
            case let .failure(error):
                print("Update error: \(error)")
            }
        }
    }
}
```

### Delete Entity

The `deleteEntity` method deletes an entity by its ID.

```swift
func deleteEntity(withId id: String) {
    dataStore.delete(entityId: id) { [weak self] result in
        DispatchQueue.main.async {
            switch result {
            case .success:
                self?.entities.removeAll { $0.id == id }
                print("Entity deleted successfully")
            case let .failure(error):
                print("Delete error: \(error)")
            }
        }
    }
}
```

## Query Struct

The `Query` struct defines querying mechanisms with predicates, sorting, and more.

### Struct Definition

```swift
struct Query<T: Codable & Identifiable> {
    // Logical conditions to filter data.
    var predicate: NSCompoundPredicate?

    // Criteria for sorting the results.
    var sortDescriptors: [NSSortDescriptor]?

    // Fields to be retrieved in the query, useful for data efficiency.
    var fields: [String]?

    // Aggregations like count, sum applied to query results.
    var aggregations: [Aggregation]?

    // Maximum number of records to retrieve.
    var limit: Int?

    // Offset where to start fetching records (for pagination).
    var offset: Int?

    // Specifications for joining with other data models.
    var joins: [Join<T>]?

    // Ensures that only unique records are returned based on specified fields.
    var distinctOnFields: [String]?

    // Custom logical expressions applied to filter or modify data.
    var customExpressions: [CustomExpression<T>]?

    // Factory method to initialize a query with a filter predicate.
    static func filter(_ predicate: NSCompoundPredicate) -> Query {
        Query(predicate: predicate)
    }

    // Factory method to initialize a query with sorting descriptors.
    static func sort(_ sortDescriptors: [NSSortDescriptor]) -> Query {
        Query(sortDescriptors: sortDescriptors)
    }

    // Factory method to specify which fields to fetch in the query.
    static func fields(_ fields: [String]) -> Query {
        Query(fields: fields)
    }

    // Factory method to add aggregation functions to the query.
    static func aggregate(_ aggregations: [Aggregation]) -> Query {
        Query(aggregations: aggregations)
    }

    // Factory method to set the limit and offset for the query results.
    static func limit(_ limit: Int, offset: Int = 0) -> Query {
        Query(limit: limit, offset: offset)
    }

    // Factory method to define joins with other data models.
    static func join(_ joins: [Join<T>]) -> Query {
        Query(joins: joins)
    }

    // Factory method to enforce that the query results are distinct based on specified fields.
    static func distinct(on fields: [String]) -> Query {
        Query(distinctOnFields: fields)
    }

    // Factory method to apply custom expressions to the query.
    static func custom(_ expressions: [CustomExpression<T>]?) -> Query {
        Query(customExpressions: expressions)
    }
}
```

## Aggregation Enum

The `Aggregation` enum defines aggregation functions for queries.

### Enum Definition

```swift
enum Aggregation {
    case count(String)
    case sum(String)
    case average(String)
    case min(String)
    case max(String)
    case groupBy([String], [Aggregation])
}
```

## Join Struct

The `Join` struct represents join operations between data models.

### Struct Definition

```swift
struct Join<T: Codable & Identifiable> {
    let type: JoinType // Type of join operation (inner, leftOuter, etc.)
    let target: T.Type // The model type to join with.
    let on: NSPredicate // Condition on which to join.
}
```

## JoinType Enum

The `JoinType` enum enumerates different types of join operations.

### Enum Definition

```swift
enum JoinType {
    case inner
    case leftOuter
    case rightOuter
    case fullOuter
}
```

## CustomExpression Struct

The `CustomExpression` struct allows custom expressions in queries.

### Struct Definition

```swift
struct CustomExpression<T: Codable> {
    let expression: (T) -> Bool // A function that evaluates to true or false based on custom logic.
}
```

## Practical Usage Examples

## DataStore
### Adding a User

To add a new user to the data store:

```swift
let newUser = UserModel(id: "1", name: "John Doe", email: "john.doe@example.com")
DataStore.shared.upsert(.user, model: newUser)
```

### Retrieving

Retrieving a User

To retrieve a user from the data store:

```swift
if let user: UserModel = DataStore.shared.getObject(for: .user, as: UserModel.self) {
    print("User: \(user.name), Email: \(user.email)")
}
```

### Updating a User

To update an existing user from data store:

```swift
var updatedUser = UserModel(id: "1", name: "John Doe", email: "john.doe@example.com")
updatedUser.name = "John Doe Jr."
DataStore.shared.upsert(.user, model: updatedUser)
```

### Using DataStore in SwiftUI

To use DataStore in a SwiftUI view with dependency injection:
Set up the environment key for DataStore:

```swift
private struct DataStoreKey: EnvironmentKey {
    static let defaultValue: DataStore = .shared
}

extension EnvironmentValues {
    var dataStore: DataStore {
        get { self[DataStoreKey.self] }
        set { self[DataStoreKey.self] = newValue }
    }
}
```

Create a SwiftUI view that uses DataStore:

```swift
struct ContentView: View {
    @Environment(\.dataStore) private var dataStore: DataStore
    @State private var users: [UserModel] = []

    var body: some View {
        VStack {
            List(users, id: \.id) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                    Text(user.email)
                }
            }
            Button(action: addUser) {
                Text("Add User")
            }
        }
        .onAppear(perform: loadUsers)
    }

    private func loadUsers() {
        if let user: UserModel = dataStore.getObject(for: .user, as: UserModel.self) {
            users.append(user)
        }
    }

    private func addUser() {
        let newUser = UserModel(id: UUID().uuidString, name: "New User", email: "new.user@example.com")
        dataStore.upsert(.user, model: newUser)
        loadUsers()
    }
}
```

Provide the DataStore to the SwiftUI view hierarchy:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dataStore, DataStore.shared)
        }
    }
}
```


## ModelContext

### Deleting a User

To delete a user:

```swift
do {
    let userToDelete = UserModel(id: "1", name: "John Doe", email: "john.doe@example.com")
    try ModelContext(ModelContainer()).delete(userToDelete)
} catch {
    print("Error deleting user: \(error)")
}
```

### Querying Users

To query users based on certain criteria:

```swift
let predicate = NSPredicate(format: "name CONTAINS[c] %@", "John")
let query = Query<UserModel>.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [predicate]))
let users = ModelContainer().execute(query: query)

for user in users {
    print("User: \(user.name), Email: \(user.email)")
}
```
