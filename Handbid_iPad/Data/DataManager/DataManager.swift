// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftData
import SwiftUI

// Define a dummy OtherModel
struct OtherModel: Identifiable, Codable {
	var id: UUID // Make sure ID is non-optional UUID
	// Additional properties
}

class ModelContext {
	private var container: ModelContainer
	var autosaveEnabled: Bool = true

	init(_ container: ModelContainer) {
		self.container = container
	}

	func model<T: Identifiable & Codable>(for id: UUID) -> T? {
		container.fetch(id: id)
	}

	func save(_ item: some Identifiable & Codable) throws {
		if autosaveEnabled {
			try container.save(item)
		}
	}

	func update(_ item: some Identifiable & Codable) throws {
		if autosaveEnabled {
			try container.update(item)
		}
	}

	func delete(item: some Identifiable & Codable) throws {
		if autosaveEnabled {
			try container.delete(item)
		}
	}
}

class ServicesData {
	static let shared = ServicesData()
	let otherModelDataManager: DataManager<OtherModel> = AppDependencyContainer.shared.myModelDataManager

    let auctionModelDataManager: DataManager<OtherModel> = AppDependencyContainer.shared.myModelDataManager

}

extension EnvironmentValues {
	var appServices: ServicesData {
		get { self[AppServicesKey.self] }
		set { self[AppServicesKey.self] = newValue }
	}
}

private struct AppServicesKey: EnvironmentKey {
	static let defaultValue: ServicesData = .shared
}

class AppDependencyContainer {
	static let shared = AppDependencyContainer()
	//let modelDataStore: InMemoryDataStore<OtherModel> = .init()
    lazy var myModelDataManager: DataManager<OtherModel> = DataManager(dataStore: AnyDataStore(InMemoryDataStore<OtherModel>.init()))

    lazy var auctionModelDataManager: DataManager<AuctionModel> = DataManager(dataStore: AnyDataStore(InMemoryDataStore<AuctionModel>.init()))

}

class ModelContainer {
	private var items: [UUID: Any] = [:]

	func fetch<T: Identifiable & Codable>(id: UUID) -> T? {
		items[id] as? T
	}

	func save(_ item: some Identifiable & Codable) throws {
		guard let id = item.id as? UUID else {
			throw NSError(domain: "ModelContainerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID for item."])
		}
		items[id] = item
	}

	func delete(_ item: some Identifiable & Codable) throws {
		guard let id = item.id as? UUID else {
			throw NSError(domain: "ModelContainerError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid ID for item."])
		}
		items.removeValue(forKey: id)
	}

	func loadAll<T: Identifiable & Codable>() -> [T] {
		items.values.compactMap { $0 as? T }
	}

	func update(_ item: some Identifiable & Codable) throws {
		guard let id = item.id as? UUID else {
			throw NSError(domain: "ModelContainerError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid ID for item during update."])
		}
		guard items.keys.contains(id) else {
			throw NSError(domain: "ModelContainerError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Item not found for update."])
		}
		items[id] = item
	}

	func filter<T: Identifiable & Codable>(_ predicate: NSPredicate) -> [T] {
		let allItems = items.values.compactMap { $0 as? T }
		return (allItems as NSArray).filtered(using: predicate) as! [T]
	}

	func execute<T: Identifiable & Codable>(query: Query<T>) -> [T] {
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
	associatedtype T: Identifiable & Codable where T.ID == UUID // Ensures that the ID must be a UUID
	var updates: AnyPublisher<T, Never> { get }
	func load(completion: @escaping (Result<[T], Error>) -> Void)
	func save(item: T, completion: @escaping (Result<Void, Error>) -> Void)
	func update(item: T, completion: @escaping (Result<Void, Error>) -> Void)
	func delete(itemId: UUID, completion: @escaping (Result<Void, Error>) -> Void)
}

class AnyDataStore<T: Identifiable & Codable>: DataStore where T.ID == UUID {
	private var innerLoad: (@escaping (Result<[T], Error>) -> Void) -> Void
	private var innerSave: (T, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerUpdate: (T, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerDelete: (UUID, @escaping (Result<Void, Error>) -> Void) -> Void
	var updates: AnyPublisher<T, Never>

	init<Store: DataStore>(_ store: Store) where Store.T == T {
		self.innerLoad = store.load
		self.innerSave = store.save
		self.innerUpdate = store.update
		self.innerDelete = store.delete
		self.updates = store.updates
	}

	func load(completion: @escaping (Result<[T], Error>) -> Void) {
		innerLoad(completion)
	}

	func save(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		innerSave(item, completion)
	}

	func update(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		innerUpdate(item, completion)
	}

	func delete(itemId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
		innerDelete(itemId, completion)
	}
}

// MARK: - In-Memory Data Store

class InMemoryDataStore<T: Identifiable & Codable>: DataStore where T.ID == UUID {
	private var items: [UUID: T] = [:]
	private let updateSubject = PassthroughSubject<T, Never>()

	var updates: AnyPublisher<T, Never> {
		updateSubject.eraseToAnyPublisher()
	}

	func load(completion: @escaping (Result<[T], Error>) -> Void) {
		completion(.success(Array(items.values)))
	}

	func save(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		items[item.id] = item
		updateSubject.send(item)
		completion(.success(()))
	}

	func update(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		if let _ = items.updateValue(item, forKey: item.id) {
			updateSubject.send(item)
			completion(.success(()))
		}
		else {
			completion(.failure(NSError(domain: "UpdateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Item not found"])))
		}
	}

	func delete(itemId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
		if let _ = items.removeValue(forKey: itemId) {
			completion(.success(()))
		}
		else {
			completion(.failure(NSError(domain: "DeleteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Item not found"])))
		}
	}
}

// MARK: - Repository Implementation

class DataManager<T: Identifiable & Codable>: ObservableObject where T.ID == UUID {
	@Published var items: [T] = []
	private var cancellables: Set<AnyCancellable> = []
	private var dataStore: AnyDataStore<T>

	init(dataStore: AnyDataStore<T>) {
		self.dataStore = dataStore
		dataStore.updates
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] item in
				if let index = self?.items.firstIndex(where: { $0.id == item.id }) {
					self?.items[index] = item
				}
				else {
					self?.items.append(item)
				}
			})
			.store(in: &cancellables)

		loadItems()
	}

	func loadItems() {
		dataStore.load { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case let .success(items):
					self?.items = items
				case let .failure(error):
					print("Error loading items: \(error)")
				}
			}
		}
	}

	func saveItem(_ item: T) {
		dataStore.save(item: item) { result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					print("Item saved successfully")
				case let .failure(error):
					print("Save error: \(error)")
				}
			}
		}
	}

	func updateItem(_ item: T) {
		dataStore.update(item: item) { result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					print("Item updated successfully")
				case let .failure(error):
					print("Update error: \(error)")
				}
			}
		}
	}

	func deleteItem(withId id: UUID) {
		dataStore.delete(itemId: id) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success():
					self?.items.removeAll { $0.id == id }
					print("Item deleted successfully")
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
