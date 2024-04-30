// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct AddressModel: Decodable, NetworkingJSONDecodable {
	var street: String?
	var city: String?
	var state: String?
	var postalCode: String?
	var country: String?
}

extension AddressModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		street <-- json["street"]
		city <-- json["city"]
		state <-- json["state"]
		postalCode <-- json["postalCode"]
		country <-- json["country"]
	}
}
