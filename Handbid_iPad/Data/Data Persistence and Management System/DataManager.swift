// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

protocol DataManagementService {
    func create<T: Codable & Identifiable>(_ item: T, in model: ModelType) throws where T.ID == String
    func fetchAll<T: Codable & Identifiable>(of type: T.Type, from model: ModelType) throws -> [T] where T.ID == String
    func fetchSingle<T: Codable & Identifiable>(of type: T.Type, from model: ModelType) throws -> T? where T.ID == String
    func update<T: Codable & Identifiable>(_ item: T, withNestedUpdates allowNested: Bool, in model: ModelType) throws where T.ID == String
    func delete<T: Codable & Identifiable>(_ item: T, from model: ModelType) throws where T.ID == String
    var onDataChanged: AnyPublisher<Void, Never> { get }
}

class DataManager: DataManagementService {
    private var database: DatabaseService
    private var changeNotifier = PassthroughSubject<Void, Never>()

    var onDataChanged: AnyPublisher<Void, Never> {
        changeNotifier.eraseToAnyPublisher()
    }

    init(database: DatabaseService) {
        self.database = database
    }

    func create<T: Codable & Identifiable>(_ item: T, in model: ModelType) throws where T.ID == String {
        try database.save(item, modelType: model)
        changeNotifier.send()
    }

    func fetchAll<T: Codable & Identifiable>(of type: T.Type, from model: ModelType) throws -> [T] where T.ID == String {
        try database.fetchAll(type, modelType: model)
    }

    func fetchSingle<T: Codable & Identifiable>(of type: T.Type, from model: ModelType) throws -> T? where T.ID == String {
        let items = try fetchAll(of: type, from: model)
        return items.first
    }

    func update<T: Codable & Identifiable>(_ item: T, withNestedUpdates allowNested: Bool, in model: ModelType) throws where T.ID == String {
        if allowNested {
            if try database.fetchOne(T.self, modelType: model, id: item.id) == nil {
                try database.save(item, modelType: model)
            } else {
                try database.update(item, modelType: model)
            }
        } else {
            try database.update(item, modelType: model)
        }
        changeNotifier.send()
    }

    func delete<T: Codable & Identifiable>(_ item: T, from model: ModelType) throws where T.ID == String {
        try database.delete(item, modelType: model)
        changeNotifier.send()
    }
}

// MARK: - Singleton Accessor Extension
extension DataManager {
    static let shared = DataManager(database: DatabaseService())
}
