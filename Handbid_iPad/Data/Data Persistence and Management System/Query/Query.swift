// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

struct Query<T: Codable & Identifiable> {
	// Logical conditions to filter data.
	var predicate: NSCompoundPredicate?

	// Criteria for sorting the results.
	var sortDescriptors: [NSSortDescriptor]?

	// Fields to be retrieved in the query, useful for data efficiency.
	var fields: [String]?

	// Aggregations like count, sum applied to query results.
	var aggregations: [Aggregation]?

	// Maximum number of records to retrieve.
	var limit: Int?

	// Offset where to start fetching records (for pagination).
	var offset: Int?

	// Specifications for joining with other data models.
	var joins: [Join<T>]?

	// Ensures that only unique records are returned based on specified fields.
	var distinctOnFields: [String]?

	// Custom logical expressions applied to filter or modify data.
	var customExpressions: [CustomExpression<T>]?

	// Factory method to initialize a query with a filter predicate.
	static func filter(_ predicate: NSCompoundPredicate) -> Query {
		Query(predicate: predicate)
	}

	// Factory method to initialize a query with sorting descriptors.
	static func sort(_ sortDescriptors: [NSSortDescriptor]) -> Query {
		Query(sortDescriptors: sortDescriptors)
	}

	// Factory method to specify which fields to fetch in the query.
	static func fields(_ fields: [String]) -> Query {
		Query(fields: fields)
	}

	// Factory method to add aggregation functions to the query.
	static func aggregate(_ aggregations: [Aggregation]) -> Query {
		Query(aggregations: aggregations)
	}

	// Factory method to set the limit and offset for the query results.
	static func limit(_ limit: Int, offset: Int = 0) -> Query {
		Query(limit: limit, offset: offset)
	}

	// Factory method to define joins with other data models.
	static func join(_ joins: [Join<T>]) -> Query {
		Query(joins: joins)
	}

	// Factory method to enforce that the query results are distinct based on specified fields.
	static func distinct(on fields: [String]) -> Query {
		Query(distinctOnFields: fields)
	}

	// Factory method to apply custom expressions to the query.
	static func custom(_ expressions: [CustomExpression<T>]?) -> Query {
		Query(customExpressions: expressions)
	}
}
