// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import SwiftData

struct OrganizationModel: Decodable, NetworkingJSONDecodable {
	@Attribute(.unique) var id: Int?
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
	enum CodingKeys: String, CodingKey {
		case id, organizationGuid, key, name, organizationDescription = "description", organizationPhone, ein, contactName, email, website, isPublic, totalAuctions, activeAuctions, logo, banner, socialFacebook, socialGoogle, socialTwitter, socialPinterest, socialLinkedin, businessType, classification, provinceCode, organizationAddressStreet1, organizationAddressStreet2, organizationAddressCity, organizationAddressPostalCode, organizationAddressProvince, organizationAddressCountry, organizationAddressProvinceId, organizationAddressCountryId, organizationImages
	}

//	init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		self.id = try container.decodeIfPresent(Int.self, forKey: .id)
//		self.organizationGuid = try container.decodeIfPresent(String.self, forKey: .organizationGuid)
//		self.key = try container.decodeIfPresent(String.self, forKey: .key)
//		self.name = try container.decodeIfPresent(String.self, forKey: .name)
//		self.organizationDescription = try container.decodeIfPresent(String.self, forKey: .organizationDescription)
//		self.organizationPhone = try container.decodeIfPresent(String.self, forKey: .organizationPhone)
//		self.ein = try container.decodeIfPresent(String.self, forKey: .ein)
//		self.contactName = try container.decodeIfPresent(String.self, forKey: .contactName)
//		self.email = try container.decodeIfPresent(String.self, forKey: .email)
//		self.website = try container.decodeIfPresent(String.self, forKey: .website)
//		self.isPublic = try container.decodeIfPresent(Int.self, forKey: .isPublic)
//		self.totalAuctions = try container.decodeIfPresent(Int.self, forKey: .totalAuctions)
//		self.activeAuctions = try container.decodeIfPresent(Int.self, forKey: .activeAuctions)
//		self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
//		self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
//		self.socialFacebook = try container.decodeIfPresent(String.self, forKey: .socialFacebook)
//		self.socialGoogle = try container.decodeIfPresent(String.self, forKey: .socialGoogle)
//		self.socialTwitter = try container.decodeIfPresent(String.self, forKey: .socialTwitter)
//		self.socialPinterest = try container.decodeIfPresent(String.self, forKey: .socialPinterest)
//		self.socialLinkedin = try container.decodeIfPresent(String.self, forKey: .socialLinkedin)
//		self.businessType = try container.decodeIfPresent(String.self, forKey: .businessType)
//		self.classification = try container.decodeIfPresent(String.self, forKey: .classification)
//		self.provinceCode = try container.decodeIfPresent(String.self, forKey: .provinceCode)
//		self.organizationAddressStreet1 = try container.decodeIfPresent(String.self, forKey: .organizationAddressStreet1)
//		self.organizationAddressStreet2 = try container.decodeIfPresent(String.self, forKey: .organizationAddressStreet2)
//		self.organizationAddressCity = try container.decodeIfPresent(String.self, forKey: .organizationAddressCity)
//		self.organizationAddressPostalCode = try container.decodeIfPresent(String.self, forKey: .organizationAddressPostalCode)
//		self.organizationAddressProvince = try container.decodeIfPresent(String.self, forKey: .organizationAddressProvince)
//		self.organizationAddressCountry = try container.decodeIfPresent(String.self, forKey: .organizationAddressCountry)
//		self.organizationAddressProvinceId = try container.decodeIfPresent(Int.self, forKey: .organizationAddressProvinceId)
//		self.organizationAddressCountryId = try container.decodeIfPresent(Int.self, forKey: .organizationAddressCountryId)
//		self.organizationImages = try container.decodeIfPresent([OrganizationImageModel].self, forKey: .organizationImages)
//	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
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
