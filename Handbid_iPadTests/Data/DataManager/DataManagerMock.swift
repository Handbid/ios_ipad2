// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class DataManagerMock: DataManager {
	private var items: [ModelType: [String: Codable]] = [:]
	private var changeNotifier = PassthroughSubject<Void, Never>()

	override var onDataChanged: AnyPublisher<Void, Never> {
		changeNotifier.eraseToAnyPublisher()
	}

	init(database: DatabaseServiceMock) {
		super.init(database: database)
	}

	override func create<T>(_ item: T, in model: ModelType) throws where T: Codable, T: Identifiable, T.ID == String {
		var modelItems = items[model] ?? [:]
		modelItems[item.id] = item
		items[model] = modelItems
		changeNotifier.send()
	}

	override func fetchAll<T>(of _: T.Type, from model: ModelType) throws -> [T] where T: Codable, T: Identifiable, T.ID == String {
		items[model]?.values.compactMap { $0 as? T } ?? []
	}

	override func fetchSingle<T>(of type: T.Type, from model: ModelType) throws -> T? where T: Codable, T: Identifiable, T.ID == String {
		try fetchAll(of: type, from: model).first
	}

	override func update<T>(_ item: T, withNestedUpdates allowNested: Bool, in model: ModelType) throws where T: Codable, T: Identifiable, T.ID == String {
		if allowNested {
			if try fetchSingle(of: T.self, from: model) == nil {
				try create(item, in: model)
			}
			else {
				items[model]?[item.id] = item
			}
		}
		else {
			items[model]?[item.id] = item
		}
		changeNotifier.send()
	}

	override func delete<T>(_ item: T, from model: ModelType) throws where T: Codable, T: Identifiable, T.ID == String {
		items[model]?.removeValue(forKey: item.id)
		changeNotifier.send()
	}

	override func deleteAll<T>(of _: T.Type, from model: ModelType) throws where T: Codable, T: Identifiable, T.ID == String {
		items[model]?.removeAll()
		changeNotifier.send()
	}
}
