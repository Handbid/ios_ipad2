// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftData

class SwiftDataDatabase {
	private var storage: [String: Data] = [:]

	func save<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		let key = modelTypeKey(modelType, id: item.id)
		let data = try JSONEncoder().encode(item)
		storage[key] = data
	}

	func fetchAll<T: Codable & Identifiable>(_: T.Type, modelType: ModelTypeData) throws -> [T] where T.ID == String {
		let keyPrefix = modelTypeKeyPrefix(modelType)
		return try storage.keys.filter { $0.hasPrefix(keyPrefix) }
			.compactMap { key -> T? in
				guard let data = storage[key] else { return nil }
				return try JSONDecoder().decode(T.self, from: data)
			}
	}

	func update<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		try save(item, modelType: modelType)
	}

	func delete<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		let key = modelTypeKey(modelType, id: item.id)
		storage.removeValue(forKey: key)
	}

	private func modelTypeKey(_ modelType: ModelTypeData, id: String) -> String {
		"\(modelType)_\(id)"
	}

	private func modelTypeKeyPrefix(_ modelType: ModelTypeData) -> String {
		"\(modelType)_"
	}
}
