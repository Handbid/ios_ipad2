// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct AboutModel: Decodable, NetworkingJSONDecodable {
	var banner: Banner?
	var images: [String]?
}

extension AboutModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		banner <-- json["banner"]
		images <-- json["images"]
	}
}
