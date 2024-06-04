// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class DatabaseServiceMock: DatabaseService {
	private var storage: [ModelType: [String: Codable]] = [:]

	override func save<T: Codable & Identifiable>(_ item: T, modelType: ModelType) throws where T.ID == String {
		var modelItems = storage[modelType] ?? [:]
		modelItems[item.id] = item
		storage[modelType] = modelItems
	}

	override func fetchAll<T: Codable & Identifiable>(_: T.Type, modelType: ModelType) throws -> [T] where T.ID == String {
		storage[modelType]?.values.compactMap { $0 as? T } ?? []
	}

	func fetchOne<T: Codable & Identifiable>(_: T.Type, modelType: ModelType, id: String) throws -> T? where T.ID == String {
		storage[modelType]?[id] as? T
	}

	override func update<T: Codable & Identifiable>(_ item: T, modelType: ModelType) throws where T.ID == String {
		guard var modelItems = storage[modelType], modelItems[item.id] != nil else { throw NSError() }
		modelItems[item.id] = item
		storage[modelType] = modelItems
	}

	override func delete<T: Codable & Identifiable>(_ item: T, modelType: ModelType) throws where T.ID == String {
		var modelItems = storage[modelType] ?? [:]
		modelItems.removeValue(forKey: item.id)
		storage[modelType] = modelItems
	}
}
