// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Foundation
import NetworkService

public extension ArrowParsable where Self: NetworkingJSONDecodable {
	static func decode(_ json: Any) throws -> Self {
		var t = Self()
		if let arrowJSON = JSON(json) {
			t.deserialize(arrowJSON)
		}
		return t
	}
}
