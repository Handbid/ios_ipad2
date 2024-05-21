// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

class AnyDataStore<Entity: Identifiable & Codable>: DataStoreProtocool {
	private var innerLoad: (@escaping (Result<[Entity], Error>) -> Void) -> Void
	private var innerSave: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerUpdate: (Entity, @escaping (Result<Void, Error>) -> Void) -> Void
	private var innerDelete: (String, @escaping (Result<Void, Error>) -> Void) -> Void
	var updates: AnyPublisher<Entity, Never>

	init<Store: DataStoreProtocool>(_ store: Store) where Store.Entity == Entity {
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
