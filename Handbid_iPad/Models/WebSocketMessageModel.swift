// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct WebSocketMessageModel<T: Codable>: Codable, NetworkingJSONDecodable {
	var values: T?
	var attributes: [String]
	var model: String
}

extension WebSocketMessageModel: ArrowParsable {
	init() {
		self.attributes = []
		self.model = ""
	}

	mutating func deserialize(_ json: JSON) {
		values <-- json["values"]
		attributes <-- json["attributes"]
		model <-- json["model"]
	}
}
