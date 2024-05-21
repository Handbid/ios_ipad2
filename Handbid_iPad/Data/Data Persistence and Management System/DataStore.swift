// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

final class DataStore: ObservableObject {
	static let shared = DataStore()

	private(set) var storedModels: [ModelTypeData: AnyObject] = [:]
	private var modelsPublisherSubject = PassthroughSubject<Void, Never>()

	private init() {}

	var modelsPublisher: AnyPublisher<Void, Never> {
		modelsPublisherSubject.eraseToAnyPublisher()
	}

	func fetchModel<T: Codable>(ofType modelType: ModelTypeData, as _: T.Type) -> T? {
		let result = storedModels[modelType] as? T
		return result
	}

	private func mergeModels<T: Codable>(_ oldModel: T, with newModel: T) -> T {
		guard let newData = try? JSONEncoder().encode(newModel),
		      let updatedModel = try? JSONDecoder().decode(T.self, from: newData)
		else {
			return oldModel
		}
		return updatedModel
	}

	func upsertModel<T: Codable>(_ modelType: ModelTypeData, model: T?, allowCreation: Bool) {
		guard modelType.isModelType(T.self) else {
			print("Error: Model type mismatch.")
			return
		}

		if let model {
			if let existingModel = storedModels[modelType] as? T {
				let updatedModel = mergeModels(existingModel, with: model)
				saveModel(updatedModel, for: modelType)
			}
			else if allowCreation {
				saveModel(model, for: modelType)
			}
			else {
				print("Model of type \(modelType) does not exist and creation is not allowed.")
			}
		}
	}

	private func saveModel(_ model: some Any, for modelType: ModelTypeData) {
		storedModels[modelType] = model as AnyObject
		modelsPublisherSubject.send()
	}

	func clearModel(ofType modelType: ModelTypeData) {
		storedModels.removeValue(forKey: modelType)
		modelsPublisherSubject.send()
	}

	func clearAllModels() {
		storedModels.removeAll()
		modelsPublisherSubject.send()
	}
}
