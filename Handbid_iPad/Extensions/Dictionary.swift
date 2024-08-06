// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

extension [String: any CustomStringConvertible] {
	mutating func addOptional(key: Key, value: Value?) {
		if let value {
			self[key] = value
		}
	}
}
