// Copyright (c) 2024 by Handbid. All rights reserved.

protocol Manageable {
	associatedtype Identifier: Equatable
	var id: Identifier? { get set }
	static func fetchAll() -> [Self]
	static func fetchFiltered(by predicate: NSPredicate) -> [Self]
	func save()
	func delete()
}
