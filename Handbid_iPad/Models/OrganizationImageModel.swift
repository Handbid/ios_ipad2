// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct OrganizationImageModel: Decodable, NetworkingJSONDecodable {
	var imageId: Int?
	var imageGuid: String?
	var caption: String?
	var fileName: String?
	var imageUrl: String?
}

extension OrganizationImageModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		imageId <-- json["organizationImageId"]
		imageGuid <-- json["organizationImageGuid"]
		caption <-- json["organizationImageCaption"]
		fileName <-- json["organizationImageFileName"]
		imageUrl <-- json["organizationImageUrl"]
	}
}
