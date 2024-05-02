// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct Banner: Decodable, NetworkingJSONDecodable {
	var imageUrl: String?
	var link: String?
}

extension Banner: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		imageUrl <-- json["imageUrl"]
		link <-- json["link"]
	}
}
