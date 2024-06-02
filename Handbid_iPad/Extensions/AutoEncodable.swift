// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

protocol AutoEncodable: Encodable {
	func encode(to encoder: Encoder) throws
}

extension AutoEncodable {
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: AnyCodingKey.self)
		let mirror = Mirror(reflecting: self)

		for child in mirror.children {
			if let key = child.label {
				let codingKey = AnyCodingKey(stringValue: key)
				let value = child.value

				if value is NSNull || (value as? OptionalProtocol)?.isNil ?? false {
					continue
				}

				if let encodableValue = value as? Encodable {
					try encodableValue.encode(to: container.superEncoder(forKey: codingKey))
				}
				else {
					let context = EncodingError.Context(codingPath: container.codingPath + [codingKey],
					                                    debugDescription: "Value for key \(key) is not encodable")
					throw EncodingError.invalidValue(value, context)
				}
			}
		}
	}
}

struct AnyCodingKey: CodingKey {
	var stringValue: String
	var intValue: Int?

	init(stringValue: String) {
		self.stringValue = stringValue
		self.intValue = nil
	}

	init(intValue: Int) {
		self.stringValue = "\(intValue)"
		self.intValue = intValue
	}
}

protocol OptionalProtocol {
	var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
	var isNil: Bool {
		switch self {
		case .none: true
		case .some: false
		}
	}
}
