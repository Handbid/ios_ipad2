// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

// Represents a join operation between two data models.
struct Join<T: Codable & Identifiable> {
	let type: JoinType // Type of join operation (inner, leftOuter, etc.)
	let target: T.Type // The model type to join with.
	let on: NSPredicate // Condition on which to join.
}
