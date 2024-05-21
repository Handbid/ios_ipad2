// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

protocol HasIdentity {
	var identity: Int { get }
}

protocol HasNestedModels {
	var nestedModels: [AnyObject] { get set }
}

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

	func upsertModel<T: Codable>(_ modelType: ModelTypeData, model: T?, allowCreation: Bool, shouldMerge: Bool = false) {
		guard modelType.isModelType(T.self) else {
			print("Error: Model type mismatch.")
			return
		}

		if let model {
			if let existingModel = storedModels[modelType] as? T {
				let updatedModel: T = shouldMerge ? mergeModels(existingModel, with: model) : model
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

	private func findNestedModel<T: Codable & HasIdentity>(_ modelType: ModelTypeData, identity: Int) -> T? {
		guard let parentModel = storedModels[modelType] as? HasNestedModels else { return nil }
		return parentModel.nestedModels.first { ($0 as? T)?.identity == identity } as? T
	}

	func upsertNestedModel<T: Codable & HasIdentity>(_ modelType: ModelTypeData, nestedModel: T, identity: Int, allowAddition: Bool, shouldMerge: Bool = false) {
		guard var parentModel = storedModels[modelType] as? HasNestedModels else {
			print("Error: Parent model type mismatch or not found.")
			return
		}

		if let existingNestedModel: T = findNestedModel(modelType, identity: identity) {
			let updatedNestedModel = shouldMerge ? mergeModels(existingNestedModel, with: nestedModel) : nestedModel
			if let index = parentModel.nestedModels.firstIndex(where: { ($0 as? HasIdentity)?.identity == identity }) {
				parentModel.nestedModels[index] = updatedNestedModel as AnyObject
			}
		}
		else if allowAddition {
			parentModel.nestedModels.append(nestedModel as AnyObject)
		}
		else {
			print("Nested model with identity \(identity) does not exist and addition is not allowed.")
			return
		}

		storedModels[modelType] = parentModel as AnyObject
		modelsPublisherSubject.send()
	}
}
