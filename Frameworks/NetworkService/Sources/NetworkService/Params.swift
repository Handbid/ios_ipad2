// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

public typealias Params = [String: CustomStringConvertible]

public extension Params {
	func asPercentEncodedString(parentKey: String? = nil) -> String {
		map { key, value in
			var escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			if let parentKey {
				escapedKey = "\(parentKey)[\(escapedKey)]"
			}

			if let dict = value as? Params {
				return dict.asPercentEncodedString(parentKey: escapedKey)
			}
			else if let array = value as? [CustomStringConvertible] {
				return array.map { entry in
					let escapedValue = "\(entry)"
						.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
					return "\(escapedKey)[]=\(escapedValue)"
				}.joined(separator: "&")
			}
			else {
				let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
				return "\(escapedKey)=\(escapedValue)"
			}
		}
		.joined(separator: "&")
	}
}
