// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct OrganizationModel: Decodable, NetworkingJSONDecodable {
	var id: Int?
	var organizationGuid: String?
	var key: String?
	var name: String?
	var description: String?
	var organizationPhone: String?
	var ein: String?
	var contactName: String?
	var email: String?
	var website: String?
	var isPublic: Bool?
	var totalAuctions: Int?
	var activeAuctions: Int?
	var logo: String?
	var banner: String?
	var socialFacebook: String?
	var socialGoogle: String?
	var socialTwitter: String?
	var socialPinterest: String?
	var socialLinkedin: String?
	var businessType: String?
	var classification: String?
	var provinceCode: String?
	var organizationAddress: OrganizationAddressModel?
	var organizationImages: [OrganizationImageModel]?
}

extension OrganizationModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		organizationGuid <-- json["organizationGuid"]
		key <-- json["key"]
		name <-- json["name"]
		description <-- json["description"]
		organizationPhone <-- json["organizationPhone"]
		ein <-- json["ein"]
		contactName <-- json["contactName"]
		email <-- json["email"]
		website <-- json["website"]
		isPublic <-- json["public"]
		totalAuctions <-- json["totalAuctions"]
		activeAuctions <-- json["activeAuctions"]
		logo <-- json["logo"]
		banner <-- json["banner"]
		socialFacebook <-- json["socialFacebook"]
		socialGoogle <-- json["socialGoogle"]
		socialTwitter <-- json["socialTwitter"]
		socialPinterest <-- json["socialPinterest"]
		socialLinkedin <-- json["socialLinkedin"]
		businessType <-- json["businessType"]
		classification <-- json["classification"]
		provinceCode <-- json["provinceCode"]
		organizationAddress <-- json["organizationAddress"]
		organizationImages <-- json["organizationImages"]
	}
}
