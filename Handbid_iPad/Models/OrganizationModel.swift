// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct OrganizationModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: String
	var identity: Int?
	var organizationGuid: String?
	var key: String?
	var name: String?
	var organizationDescription: String?
	var organizationPhone: String?
	var ein: String?
	var contactName: String?
	var email: String?
	var website: String?
	var isPublic: Int?
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
	var organizationAddressStreet1: String?
	var organizationAddressStreet2: String?
	var organizationAddressCity: String?
	var organizationAddressPostalCode: String?
	var organizationAddressProvince: String?
	var organizationAddressCountry: String?
	var organizationAddressProvinceId: Int?
	var organizationAddressCountryId: Int?
	var organizationImages: [OrganizationImageModel]?
}

extension OrganizationModel: ArrowParsable {
	init() {
		self.id = String()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["organizationGuid"]
		identity <-- json["id"]
		organizationGuid <-- json["organizationGuid"]
		key <-- json["key"]
		name <-- json["name"]
		organizationDescription <-- json["description"]
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
		organizationAddressStreet1 <-- json["organizationAddressStreet1"]
		organizationAddressStreet2 <-- json["organizationAddressStreet2"]
		organizationAddressCity <-- json["organizationAddressCity"]
		organizationAddressPostalCode <-- json["organizationAddressPostalCode"]
		organizationAddressProvince <-- json["organizationAddressProvince"]
		organizationAddressCountry <-- json["organizationAddressCountry"]
		organizationAddressProvinceId <-- json["organizationAddressProvinceId"]
		organizationAddressCountryId <-- json["organizationAddressCountryId"]
		organizationImages <-- json["organizationImages"]
	}
}
