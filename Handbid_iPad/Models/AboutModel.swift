// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct AboutModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: String
	var banner: Banner?
	var images: [String]?
}

extension AboutModel: ArrowParsable {
	init() {
		self.id = String()
	}

	mutating func deserialize(_ json: JSON) {
		banner <-- json["banner"]
		images <-- json["images"]
	}
}
