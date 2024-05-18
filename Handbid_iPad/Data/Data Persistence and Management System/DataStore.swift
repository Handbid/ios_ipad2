// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

final class DataStore: ObservableObject {
	static let shared = DataStore()

	private(set) var storedModels: [ModelTypeData: AnyObject] = [:]
	private var modelsPublisherSubject = PassthroughSubject<Void, Never>()
	private let dataStoreQueue = DispatchQueue(label: "dataStoreQueue", attributes: .concurrent)

	private init() {}

	var modelsPublisher: AnyPublisher<Void, Never> {
		modelsPublisherSubject.eraseToAnyPublisher()
	}

	// Metoda pobierania danych
	func fetchModel<T: Identifiable & Codable>(ofType modelType: ModelTypeData, as _: T.Type, fromNestedModel nestedModelType: ModelTypeData? = nil) -> T? {
		var result: T?
		dataStoreQueue.sync {
			if let nestedModelType {
				if let nestedModelsDict = storedModels[nestedModelType] as? [String: T] {
					result = nestedModelsDict.values.first(where: { model in modelType.isModelType(type(of: model)) })
				}
			}
			else {
				result = storedModels[modelType] as? T
			}
		}
		return result
	}

	// Metoda scalania danych
	private func mergeModels<T: Identifiable & Codable>(_ oldModel: T, with newModel: T) -> T {
		guard let newData = try? JSONEncoder().encode(newModel),
		      let updatedModel = try? JSONDecoder().decode(T.self, from: newData)
		else {
			return oldModel
		}
		return updatedModel
	}

	// Metoda wstawiania/aktualizacji danych
	func upsertModel<T: Identifiable & Codable>(_ modelType: ModelTypeData, model: T? = nil, newModels: [T]? = nil, allowCreation: Bool, toNestedModel nestedModelType: ModelTypeData? = nil) {
		guard modelType.isModelType(T.self) else {
			print("Error: Model type mismatch.")
			return
		}

		dataStoreQueue.async(flags: .barrier) {
			if let newModels {
				// Obsługa paginacji
				if let nestedModelType {
					var nestedModelsDict = (self.storedModels[nestedModelType] as? [String: T]) ?? [:]
					self.updateModels(&nestedModelsDict, with: newModels)
					self.saveModel(nestedModelsDict, for: nestedModelType)
				}
				else {
					var currentModelsDict = (self.storedModels[modelType] as? [String: T]) ?? [:]
					self.updateModels(&currentModelsDict, with: newModels)
					self.saveModel(currentModelsDict, for: modelType)
				}
			}
			else if let model {
				// Obsługa pojedynczego modelu
				if let nestedModelType {
					var nestedModelsDict = (self.storedModels[nestedModelType] as? [String: T]) ?? [:]
					if let modelId = model.id as? String, let existingModel = nestedModelsDict[modelId] {
						let updatedModel = self.mergeModels(existingModel, with: model)
						nestedModelsDict[modelId] = updatedModel
					}
					else if allowCreation, let modelId = model.id as? String {
						nestedModelsDict[modelId] = model
					}
					self.saveModel(nestedModelsDict, for: nestedModelType)
				}
				else {
					if let existingModel = self.storedModels[modelType] as? T {
						let updatedModel = self.mergeModels(existingModel, with: model)
						self.saveModel(updatedModel, for: modelType)
					}
					else if allowCreation {
						self.saveModel(model, for: modelType)
					}
					else {
						print("Model of type \(modelType) does not exist and creation is not allowed.")
					}
				}
			}
		}
	}

	private func saveModel(_ model: some Any, for modelType: ModelTypeData) {
		dataStoreQueue.async(flags: .barrier) {
			self.storedModels[modelType] = model as AnyObject
			DispatchQueue.main.async {
				self.modelsPublisherSubject.send()
			}
		}
	}

	private func updateModels<T: Identifiable & Codable>(_ modelsDict: inout [String: T], with newModels: [T]) {
		for newModel in newModels {
			if let modelId = newModel.id as? String {
				if let existingModel = modelsDict[modelId] {
					let updatedModel = mergeModels(existingModel, with: newModel)
					modelsDict[modelId] = updatedModel
				}
				else {
					modelsDict[modelId] = newModel
				}
			}
		}
	}

	// Metoda czyszczenia danych konkretnego modelu lub zagnieżdżonego modelu
	func clearModel(ofType modelType: ModelTypeData, fromNestedModel nestedModelType: ModelTypeData? = nil) {
		dataStoreQueue.async(flags: .barrier) {
			if let nestedModelType {
				var nestedModelsDict = (self.storedModels[nestedModelType] as? [String: Any]) ?? [:]
				nestedModelsDict.removeAll()
				self.saveModel(nestedModelsDict, for: nestedModelType)
			}
			else {
				self.storedModels.removeValue(forKey: modelType)
				DispatchQueue.main.async {
					self.modelsPublisherSubject.send()
				}
			}
		}
	}

	// Metoda czyszczenia wszystkich danych
	func clearAllModels() {
		dataStoreQueue.async(flags: .barrier) {
			self.storedModels.removeAll()
			DispatchQueue.main.async {
				self.modelsPublisherSubject.send()
			}
		}
	}
}
