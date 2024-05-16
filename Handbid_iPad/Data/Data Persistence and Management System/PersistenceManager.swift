// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

class PersistenceManager {
	private let ioQueue = DispatchQueue(label: "ioQueue", attributes: .concurrent)

	func saveToPermanentStorage<T: Codable & Identifiable>(_ entity: T) throws where T.ID == String {
		ioQueue.async(flags: .barrier) {
			let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(String(describing: T.self))_\(entity.id).json")
			let encoder = JSONEncoder()
			let decoder = JSONDecoder()
			let fileManager = FileManager.default

			if fileManager.fileExists(atPath: fileURL.path) {
				do {
					let existingData = try Data(contentsOf: fileURL)
					var existingEntity = try decoder.decode(T.self, from: existingData)

					let changes = self.mergeEntities(from: &existingEntity, into: entity)

					if changes.isEmpty {
						print("No changes detected, not writing to file.")
					}
					else {
						let newData = try encoder.encode(existingEntity)
						try newData.write(to: fileURL, options: [.atomicWrite])
						print("Data written to file: \(fileURL.path)")
						print("Updated fields: \(changes)")
						print("Updated entity: \(existingEntity)")
					}
				}
				catch {
					print("Error reading existing data or merging entities: \(error)")
				}
			}
			else {
				do {
					let newData = try encoder.encode(entity)
					try newData.write(to: fileURL, options: [.atomicWrite])
					print("Data written to file: \(fileURL.path)")
					print("New entity: \(entity)")
				}
				catch {
					print("Error writing new data to file: \(error)")
				}
			}
		}
	}

	private func mergeEntities<T: Codable>(from oldEntity: inout T, into newEntity: T) -> [String: Any] {
		let encoder = JSONEncoder()

		do {
			let fromData = try encoder.encode(oldEntity)
			let intoData = try encoder.encode(newEntity)
			var fromDict = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String: Any] ?? [:]
			let intoDict = try JSONSerialization.jsonObject(with: intoData, options: []) as? [String: Any] ?? [:]

			var changes: [String: Any] = [:]

			for (key, newValue) in intoDict {
				if let oldValue = fromDict[key], !compareValues(oldValue, newValue) {
					changes[key] = newValue
					fromDict[key] = newValue
				}
				else if fromDict[key] == nil {
					changes[key] = newValue
					fromDict[key] = newValue
				}
			}

			if !changes.isEmpty {
				let mergedData = try JSONSerialization.data(withJSONObject: fromDict, options: [])
				oldEntity = try JSONDecoder().decode(T.self, from: mergedData)
				print("Updated fields: \(changes)")
			}

			return changes
		}
		catch {
			print("Error during entity merge: \(error)")
			return [:]
		}
	}

	private func compareValues(_ oldValue: Any, _ newValue: Any) -> Bool {
		if let oldArray = oldValue as? [Any], let newArray = newValue as? [Any] {
			oldArray.elementsEqual(newArray, by: { compareValues($0, $1) })
		}
		else if let oldDict = oldValue as? [String: Any], let newDict = newValue as? [String: Any] {
			dictionariesEqual(oldDict, newDict)
		}
		else {
			"\(oldValue)" == "\(newValue)"
		}
	}

	private func dictionariesEqual(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
		guard lhs.count == rhs.count else { return false }

		for (key, lhsValue) in lhs {
			guard let rhsValue = rhs[key] else { return false }
			if !compareValues(lhsValue, rhsValue) {
				return false
			}
		}
		return true
	}

	func removeFromPermanentStorage<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		ioQueue.async(flags: .barrier) {
			let fileURL = self.getDocumentsDirectory().appendingPathComponent("\(String(describing: T.self))_\(entity.id).json")
			let fileManager = FileManager.default
			if fileManager.fileExists(atPath: fileURL.path) {
				do {
					try fileManager.removeItem(at: fileURL)
				}
				catch {
					print("Error removing file: \(error)")
				}
			}
		}
	}

	private func getDocumentsDirectory() -> URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}

	func deleteAllData() throws {
		ioQueue.async(flags: .barrier) {
			let fileManager = FileManager.default
			let documentsDirectory = self.getDocumentsDirectory()
			do {
				let files = try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
				for file in files {
					let fileURL = documentsDirectory.appendingPathComponent(file)
					try fileManager.removeItem(at: fileURL)
				}
			}
			catch {
				print("Error deleting all data: \(error)")
			}
		}
	}
}
