// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct AddressModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: String
	var street: String?
	var street1: String?
	var street2: String?
	var city: String?
	var province: String?
	var state: String?
	var postalCode: String?
	var country: String?
}

extension AddressModel: ArrowParsable {
	init() {
		self.id = String()
	}

	mutating func deserialize(_ json: JSON) {
		street <-- json["street"]
		street1 <-- json["street1"]
		street2 <-- json["street2"]
		city <-- json["city"]
		province <-- json["province"]
		state <-- json["state"]
		postalCode <-- json["postalCode"]
		country <-- json["country"]
	}
}
