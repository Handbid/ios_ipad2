// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftData

protocol SwiftDataManagerProtocol {
	func create<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String
	func fetchAll<T: Codable & Identifiable>(_ type: T.Type, modelType: ModelTypeData) throws -> [T] where T.ID == String
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

	func update<T: Codable & Identifiable>(_ item: T, nestedUpdate _: Bool, modelType: ModelTypeData) throws where T.ID == String {
		try database.update(item, modelType: modelType)
		dataChangedSubject.send()
	}

	func delete<T: Codable & Identifiable>(_ item: T, modelType: ModelTypeData) throws where T.ID == String {
		try database.delete(item, modelType: modelType)
		dataChangedSubject.send()
	}
}
