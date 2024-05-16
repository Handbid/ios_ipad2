// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

class ModelContainer {
	private var entities: [String: Any] = [:]
	private let persistenceManager = PersistenceManager()
	private let ioQueue = DispatchQueue(label: "ioQueueModelContainer", attributes: .concurrent)

	func fetch<T: Identifiable & Codable>(id: String) -> T? where T.ID == String {
		ioQueue.sync {
			entities[id] as? T
		}
	}

	func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		ioQueue.async(flags: .barrier) {
			self.entities[entity.id] = entity
			do {
				try self.persistenceManager.saveToPermanentStorage(entity)
			}
			catch {
				print("Save error: \(error)")
			}
		}
	}

	func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		ioQueue.async(flags: .barrier) {
			self.entities[entity.id] = entity
			do {
				try self.persistenceManager.saveToPermanentStorage(entity)
			}
			catch {
				print("Update error: \(error)")
			}
		}
	}

	func delete<T: Identifiable & Codable>(entity: T) throws where T.ID == String {
		ioQueue.async(flags: .barrier) {
			self.entities.removeValue(forKey: entity.id)
			do {
				try self.persistenceManager.removeFromPermanentStorage(entity)
			}
			catch {
				print("Delete error: \(error)")
			}
		}
	}

	func loadAll<T: Identifiable & Codable>() -> [T] where T.ID == String {
		ioQueue.sync {
			entities.values.compactMap { $0 as? T }
		}
	}

	func filter<T: Identifiable & Codable>(_ predicate: NSPredicate) -> [T] where T.ID == String {
		ioQueue.sync {
			let allEntities = entities.values.compactMap { $0 as? T }
			return (allEntities as NSArray).filtered(using: predicate) as! [T]
		}
	}

	func execute<T: Identifiable & Codable>(query: Query<T>) -> [T] where T.ID == String {
		ioQueue.sync {
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
}
