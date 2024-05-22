// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftData

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
