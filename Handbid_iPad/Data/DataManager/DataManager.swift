// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

private func setupDataManagers() {
	//    let auctionDataStore = LocalFileDataStore<AuctionModel>()
	//    let anyAuctionDataStore = AnyDataStore(auctionDataStore)
	//    ServiceLocator.shared.addService(DataManager<AuctionModel>(dataStore: anyAuctionDataStore), for: DataManager<AuctionModel>.self)

	let otherModelDataStore = LocalFileDataStore<OtherModel>()
	let anyOtherModelDataStore = AnyDataStore(otherModelDataStore)
	ServiceLocator.shared.addService(DataManager<OtherModel>(dataStore: anyOtherModelDataStore), for: DataManager<OtherModel>.self)
}

class AnyDataStore<T: Identifiable & Codable>: DataStore {
	private var _load: (@escaping (Result<[T], Error>) -> Void) -> Void
	private var _save: (T, @escaping (Result<Void, Error>) -> Void) -> Void
	private var _update: (T, @escaping (Result<Void, Error>) -> Void) -> Void
	private var _delete: (T.ID, @escaping (Result<Void, Error>) -> Void) -> Void

	init<Store: DataStore>(_ store: Store) where Store.T == T {
		self._load = store.load
		self._save = store.save
		self._update = store.update
		self._delete = store.delete
	}

	func load(completion: @escaping (Result<[T], Error>) -> Void) {
		_load(completion)
	}

	func save(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		_save(item, completion)
	}

	func update(item: T, completion: @escaping (Result<Void, Error>) -> Void) {
		_update(item, completion)
	}

	func delete(itemId: T.ID, completion: @escaping (Result<Void, Error>) -> Void) {
		_delete(itemId, completion)
	}
}

protocol DataStore {
	associatedtype T: Identifiable & Codable

	func load(completion: @escaping (Result<[T], Error>) -> Void)
	func save(item: T, completion: @escaping (Result<Void, Error>) -> Void)
	func update(item: T, completion: @escaping (Result<Void, Error>) -> Void)
	func delete(itemId: T.ID, completion: @escaping (Result<Void, Error>) -> Void)
}

class ServiceLocator {
	static let shared = ServiceLocator()
	private var services: [String: Any] = [:]

	func addService<T>(_ service: T, for type: T.Type) {
		let key = String(describing: type)
		services[key] = service
	}

	func getService<T>(for type: T.Type) -> T? {
		let key = String(describing: type)
		return services[key] as? T
	}
}

// Define a simple LocalFileDataStore for demonstration
class LocalFileDataStore<T: Identifiable & Codable>: DataStore {
	func load(completion _: @escaping (Result<[T], Error>) -> Void) {
		// Placeholder logic for loading data
	}

	func save(item _: T, completion _: @escaping (Result<Void, Error>) -> Void) {
		// Placeholder logic for saving data
	}

	func update(item _: T, completion _: @escaping (Result<Void, Error>) -> Void) {
		// Placeholder logic for updating data
	}

	func delete(itemId _: T.ID, completion _: @escaping (Result<Void, Error>) -> Void) {
		// Placeholder logic for deleting data
	}
}

// Define a dummy OtherModel
struct OtherModel: Identifiable, Codable {
	var id: Int?
	// Additional properties
}

class DataManager<T: Identifiable & Codable> {
	@Published var items: [T] = []
	private var dataStore: AnyDataStore<T>

	init(dataStore: AnyDataStore<T>) {
		self.dataStore = dataStore
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
		dataStore.save(item: item) { [weak self] result in
			switch result {
			case .success():
				self?.items.append(item)
			case let .failure(error):
				print("Save error: \(error)")
			}
		}
	}

	func updateItem(_ item: T) {
		guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

		dataStore.update(item: item) { [weak self] result in
			switch result {
			case .success():
				self?.items[index] = item
			case let .failure(error):
				print("Update error: \(error)")
			}
		}
	}

	func deleteItem(withId id: T.ID) {
		guard let index = items.firstIndex(where: { $0.id == id }) else { return }

		dataStore.delete(itemId: id) { [weak self] result in
			switch result {
			case .success():
				self?.items.remove(at: index)
			case let .failure(error):
				print("Delete error: \(error)")
			}
		}
	}
}
