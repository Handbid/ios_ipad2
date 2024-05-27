// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

public extension ArrowParsable where Self: NetworkingJSONDecodable {
	static func decode(_ json: Any) throws -> Self {
		var t = Self()
		if let arrowJSON = JSON(json) {
			t.deserialize(arrowJSON)
		}
		return t
	}

	static func decodeArray(_ jsonArray: Any) throws -> [Self] {
		guard let array = jsonArray as? [Any] else {
			throw NSError(domain: "DecodingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format for array decoding."])
		}

		return array.compactMap { item in
			guard let arrowJSON = JSON(item) else {
				return nil
			}
			var instance = Self()
			instance.deserialize(arrowJSON)
			return instance
		}
	}
}
