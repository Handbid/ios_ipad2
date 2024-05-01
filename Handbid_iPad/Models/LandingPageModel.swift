// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct LandingPageModel: Decodable, NetworkingJSONDecodable {
	var id: Int?
	var isPublished: Bool?
	var loadingGearsUrl: String?
}

extension LandingPageModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		isPublished <-- json["isPublished"]
		loadingGearsUrl <-- json["loadingGearsUrl"]
	}
}
