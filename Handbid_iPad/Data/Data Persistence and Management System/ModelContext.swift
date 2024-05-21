// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

class ModelContext {
	private var container: ModelContainer
	var autosaveEnabled: Bool = true
	private let updateSubject = PassthroughSubject<Void, Never>()
	private let ioQueue = DispatchQueue(label: "modelContextQueue", attributes: .concurrent)

	var updates: AnyPublisher<Void, Never> {
		updateSubject.eraseToAnyPublisher()
	}

	init(_ container: ModelContainer) {
		self.container = container
	}

	func model<T: Identifiable & Codable>(for id: String) -> T? where T.ID == String {
		container.fetch(id: id)
	}

	func save<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			ioQueue.async(flags: .barrier) {
				do {
					try self.container.save(entity)
					DispatchQueue.main.async {
						self.notifyUpdates()
					}
				}
				catch {
					print("Save error: \(error)")
				}
			}
		}
	}

	func update<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			ioQueue.async(flags: .barrier) {
				do {
					try self.container.update(entity)
					DispatchQueue.main.async {
						self.notifyUpdates()
					}
				}
				catch {
					print("Update error: \(error)")
				}
			}
		}
	}

	func delete<T: Identifiable & Codable>(_ entity: T) throws where T.ID == String {
		if autosaveEnabled {
			ioQueue.async(flags: .barrier) {
				do {
					try self.container.delete(entity: entity)
					DispatchQueue.main.async {
						self.notifyUpdates()
					}
				}
				catch {
					print("Delete error: \(error)")
				}
			}
		}
	}

	private func notifyUpdates() {
		updateSubject.send(())
	}
}
