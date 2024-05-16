// Copyright (c) 2024 by Handbid. All rights reserved.

// Defines types of aggregation functions that can be applied to query results.
enum Aggregation {
	case count(String), sum(String), average(String), min(String), max(String), groupBy([String], [Aggregation])
}
