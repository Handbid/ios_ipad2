// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct OrganizationAddressModel: Decodable, NetworkingJSONDecodable {
	var street1: String?
	var street2: String?
	var city: String?
	var postalCode: String?
	var province: String?
	var country: String?
	var provinceId: Int?
	var countryId: Int?
}

extension OrganizationAddressModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		street1 <-- json["organizationAddressStreet1"]
		street2 <-- json["organizationAddressStreet2"]
		city <-- json["organizationAddressCity"]
		postalCode <-- json["organizationAddressPostalCode"]
		province <-- json["organizationAddressProvince"]
		country <-- json["organizationAddressCountry"]
		provinceId <-- json["organizationAddressProvinceId"]
		countryId <-- json["organizationAddressCountryId"]
	}
}
