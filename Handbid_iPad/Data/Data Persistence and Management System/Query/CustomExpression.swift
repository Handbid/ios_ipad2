// Copyright (c) 2024 by Handbid. All rights reserved.

// Represents a custom expression that can be applied within a query.
struct CustomExpression<T: Codable> {
	let expression: (T) -> Bool // A function that evaluates to true or false based on custom logic.
}
