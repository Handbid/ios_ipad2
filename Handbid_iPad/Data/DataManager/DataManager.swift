// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftData
import SwiftUI

class ModelContext {
	private var container: ModelContainer
	var autosaveEnabled: Bool = true

	init(_ container: ModelContainer) {
		self.container = container
	}

	func model<T: Identifiable & Codable>(for id: String) -> T? where T.ID == String {
		container.fetch(id: id)
	}

	func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			try container.save(entity)
		}
	}

	func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			try container.update(entity)
		}
	}

	func delete<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			try container.delete(entity: entity)
		}
	}
}

class PersistenceManager {
	func saveToPermanentStorage<T: Codable & Identifiable>(_ entity: inout T) throws {
		let fileURL = getDocumentsDirectory().appendingPathComponent("\(T.self)_\(entity.id).json")
		let encoder = JSONEncoder()
		let fileManager = FileManager.default

		do {
			if fileManager.fileExists(atPath: fileURL.path) {
				let existingData = try Data(contentsOf: fileURL)
				let decoder = JSONDecoder()

				// Decoding with `var` to allow modification
				if var existingEntity = try? decoder.decode(T.self, from: existingData) {
					mergeEntities(from: &existingEntity, into: &entity)
				}
				else {
					print("Failed to decode existing entity.")
				}
			}

			let data = try encoder.encode(entity)
			try data.write(to: fileURL, options: [.atomicWrite])
		}
		catch {
			print("Error during save to permanent storage: \(error)")
			throw error
		}
	}

	private func mergeEntities<T: Codable>(from oldEntity: inout T, into newEntity: inout T) {
		let decoder = JSONDecoder()
		let encoder = JSONEncoder()

		do {
			// Encode entities to Data and then to dictionaries
			let fromData = try encoder.encode(oldEntity)
			let intoData = try encoder.encode(newEntity)
			var fromDict = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String: Any] ?? [:]
			let intoDict = try JSONSerialization.jsonObject(with: intoData, options: []) as? [String: Any] ?? [:]

			// Iterate over the new entity dictionary and update the old entity dictionary
			for (key, value) in intoDict {
				// Only update if the new value is not nil (as represented by NSNull in JSON)
				if !(value is NSNull) {
					fromDict[key] = value
				}
			}

			// Encode the merged dictionary back to Data and then decode into the old entity type
			let mergedData = try JSONSerialization.data(withJSONObject: fromDict, options: [])
			newEntity = try decoder.decode(T.self, from: mergedData)
			print("Succes update data")
		}
		catch {
			// Handle or log any errors during the merge process
			print("Error during entity merge: \(error)")
		}
	}

	func removeFromPermanentStorage<T: Identifiable & Codable>(_ entity: T) throws {
		let fileURL = getDocumentsDirectory().appendingPathComponent("\(T.self)_\(entity.id).json")
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: fileURL.path) {
			do {
				try fileManager.removeItem(at: fileURL)
			}
			catch {
				throw error
			}
		}
	}

	private func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

// MARK: - Services Data Manager for Models

class ServicesDataManager {
	static let shared = ServicesDataManager()
	//    let auctionDataManager: DataManager<AuctionModel>
	//    let organizationDataManager: DataManager<OrganizationModel>
	let userDataManager: DataManager<UserModel>

	init() {
		self.userDataManager = DependencyServiceDataContainer.shared.userDataManager
	}
}

extension EnvironmentValues {
	var appServices: ServicesDataManager {
		get { self[AppServicesKey.self] }
		set { self[AppServicesKey.self] = newValue }
	}
}

private struct AppServicesKey: EnvironmentKey {
	static let defaultValue: ServicesDataManager = .init()
}

// MARK: - Dependency Service Data Container for Data Managers

class DependencyServiceDataContainer {
	static let shared = DependencyServiceDataContainer()
	lazy var userDataManager: DataManager<UserModel> = DataManager(dataStore: AnyDataStore(InMemoryDataStore<UserModel>.init()))
}

// MARK: - Model Container Handling Generic Entity Operations

class ModelContainer {
	private var entities: [String: Any] = [:]

	func fetch<T: Identifiable & Codable>(id: String) -> T? where T.ID == String {
		entities[id] as? T
	}

	func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		entities[entity.id] = entity
	}

	func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		entities[entity.id] = entity
	}

	func delete<T: Identifiable & Codable>(entity: T) throws where T.ID == String {
		entities.removeValue(forKey: entity.id)
	}

	func loadAll<T: Identifiable & Codable>() -> [T] where T.ID == String {
		entities.values.compactMap { $0 as? T }
	}

	func filter<T: Identifiable & Codable>(_ predicate: NSPredicate) -> [T] where T.ID == String {
		let allEntities = entities.values.compactMap { $0 as? T }
		return (allEntities as NSArray).filtered(using: predicate) as! [T]
	}

	func execute<T: Identifiable & Codable>(query: Query<T>) -> [T] where T.ID == String {
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

// MARK: - Data Store Protocol

protocol DataStore {
	associatedtype Entity: Identifiable & Codable
	var updates: AnyPublisher<Entity, Never> { get }
	func load(completion: @escaping (Result<[Entity], Error>) -> Void)
	func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
	func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
	func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AnyDataStore<Entity: Identifiable & Codable>: DataStore {
	private var innerLoad: (@escaping (Result<[Entity], Error>) -> Void) -> Void
	private var innerSave: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerUpdate: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerDelete: (String, @escaping (Result<Void, Error>) -> Void) -> Void
	var updates: AnyPublisher<Entity, Never>

	init<Store: DataStore>(_ store: Store) where Store.Entity == Entity {
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

class InMemoryDataStore<Entity: Identifiable & Codable>: DataStore where Entity.ID == String {
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
		}
		else {
			completion(.failure(NSError(domain: "UpdateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
		}
	}

	func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void) {
		if let _ = entities.removeValue(forKey: entityId) {
			completion(.success(()))
		}
		else {
			completion(.failure(NSError(domain: "DeleteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
		}
	}
}

// MARK: - Repository Implementation

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
				}
				else {
					self?.entities.append(entity)
				}
			})
			.store(in: &cancellables)

		loadEntities()
	}

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
}

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
	static func custom(_ expressions: [CustomExpression<T>]) -> Query {
		Query(customExpressions: expressions)
	}
}

// Defines types of aggregation functions that can be applied to query results.
enum Aggregation {
	case count(String), sum(String), average(String), min(String), max(String), groupBy([String], [Aggregation])
}

// Represents a join operation between two data models.
struct Join<T: Codable & Identifiable> {
	let type: JoinType // Type of join operation (inner, leftOuter, etc.)
	let target: T.Type // The model type to join with.
	let on: NSPredicate // Condition on which to join.
}

// Types of joins available.
enum JoinType {
	case inner, leftOuter, rightOuter, fullOuter
}

// Represents a custom expression that can be applied within a query.
struct CustomExpression<T: Codable> {
	let expression: (T) -> Bool // A function that evaluates to true or false based on custom logic.
}
