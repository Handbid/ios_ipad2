// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

final class DataStore: ObservableObject {
	static let shared = DataStore()

	private(set) var models: [ModelTypeData: AnyObject] = [:]
	private var modelsSubject = PassthroughSubject<Void, Never>()
	private let dataStoreQueue = DispatchQueue(label: "dataStoreQueue", attributes: .concurrent)

	private init() {}

	var modelsPublisher: AnyPublisher<Void, Never> {
		modelsSubject.eraseToAnyPublisher()
	}

	func upsert<T: Identifiable & Codable>(_ modelType: ModelTypeData, model: T, allowCreation: Bool = true) {
		guard modelType.isModelType(T.self) else {
			print("Error: Model type mismatch.")
			return
		}

		dataStoreQueue.async(flags: .barrier) {
			if let existingObject = self.models[modelType] as? T {
				let updatedObject = self.merge(existingObject, with: model)
				self.setObject(updatedObject, for: modelType)
			}
			else if allowCreation {
				self.setObject(model, for: modelType)
			}
			else {
				print("Object of type \(modelType) does not exist and creation is not allowed.")
			}
		}
	}

	private func merge<T: Identifiable & Codable>(_ oldObject: T, with newObject: T) -> T {
		guard let newData = try? JSONEncoder().encode(newObject) else {
			return oldObject
		}

		guard let updatedObject = try? JSONDecoder().decode(T.self, from: newData) else {
			return oldObject
		}

		return updatedObject
	}

	private func setObject(_ object: some Identifiable & Codable, for modelType: ModelTypeData) {
		dataStoreQueue.async(flags: .barrier) {
			self.models[modelType] = object as AnyObject
			DispatchQueue.main.async {
				self.modelsSubject.send()
			}
		}
	}

	func getObject<T: Identifiable & Codable>(for modelType: ModelTypeData, as _: T.Type) -> T? {
		var result: T?
		dataStoreQueue.sync {
			result = self.models[modelType] as? T
		}
		return result
	}
}
