// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftData
import SwiftUI

protocol SwiftDataManagerProtocol {
	func create<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String
	func fetchAll<T: Codable & Identifiable>(_ type: T.Type, modelType: ModelTypeData) throws -> [T] where T.ID == String
	func fetchOne<T: Codable & Identifiable>(_ type: T.Type, modelType: ModelTypeData) throws -> T? where T.ID == String
	func update<T: Codable & Identifiable>(_ item: T, nestedUpdate: Bool, modelType: ModelTypeData) throws where T.ID == String
	func delete<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String
	var dataChanged: AnyPublisher<Void, Never> { get }
}

class SwiftDataManager: SwiftDataManagerProtocol {
	private let database: SwiftDataDatabase
	private let dataChangedSubject = PassthroughSubject<Void, Never>()

	var dataChanged: AnyPublisher<Void, Never> {
		dataChangedSubject.eraseToAnyPublisher()
	}

	init(database: SwiftDataDatabase) {
		self.database = database
	}

	func create<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		try database.save(item, modelType: modelType)
		dataChangedSubject.send()
	}

	func fetchAll<T: Codable & Identifiable>(_ type: T.Type, modelType: ModelTypeData) throws -> [T] where T.ID == String {
		try database.fetchAll(type, modelType: modelType)
	}

	func fetchOne<T: Codable & Identifiable>(_ type: T.Type, modelType: ModelTypeData) throws -> T? where T.ID == String {
		let items = try fetchAll(type, modelType: modelType)
		return items.first
	}

	func update<T: Codable & Identifiable>(_ item: T, nestedUpdate: Bool, modelType: ModelTypeData) throws where T.ID == String {
		if nestedUpdate {
			if try database.fetchOne(T.self, modelType: modelType, id: item.id) == nil {
				try database.save(item, modelType: modelType)
			}
			else {
				try database.update(item, modelType: modelType)
			}
		}
		else {
			try database.update(item, modelType: modelType)
		}
		dataChangedSubject.send()
	}

	func delete<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		try database.delete(item, modelType: modelType)
		dataChangedSubject.send()
	}
}

extension SwiftDataManager {
	static let shared = SwiftDataManager(database: SwiftDataDatabase())
}

struct SwiftDataManagerKey: EnvironmentKey {
	static let defaultValue: SwiftDataManager = .shared
}

extension EnvironmentValues {
	var swiftDataManager: SwiftDataManager {
		get { self[SwiftDataManagerKey.self] }
		set { self[SwiftDataManagerKey.self] = newValue }
	}
}
