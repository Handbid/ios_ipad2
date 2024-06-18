// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct ItemImageModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int?
	var itemImageId: Int?
	var itemImageGuid: String?
	var itemImageCaption: String?
	var itemImageFileName: String?
	var itemImageUrl: String?
}

extension ItemImageModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		itemImageId <-- json["itemImageId"]
		itemImageGuid <-- json["itemImageGuid"]
		itemImageCaption <-- json["itemImageCaption"]
		itemImageFileName <-- json["itemImageFileName"]
		itemImageUrl <-- json["itemImageUrl"]
	}
}
