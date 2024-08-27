// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CountryModel: Identifiable, Codable, NetworkingJSONDecodable {
	var id: Int?
	var name: String?
	var countryCode: String?
	var phoneCode: String?
}

extension CountryModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		name <-- json["name"]
		countryCode <-- json["countryCode"]
		phoneCode <-- json["phoneCode"]
	}
}
