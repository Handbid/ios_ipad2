// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct RegistrationModel: Decodable, NetworkingJSONDecodable {
	var firstName: String?
	var lastName: String?
	var phoneNumber: String?
	var username: String?
	var countryCode: String?
	var countryName: String?

	var email: String?
	var status: String?

	var currentPaddleNumber: String?
	var currentPlacement: String?
	var sponsorName: String?
}

extension RegistrationModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		firstName <-- json["data.firstName"]
		lastName <-- json["data.lastName"]
		phoneNumber <-- json["data.phoneNumber"]
		username <-- json["data.username"]
		countryCode <-- json["data.countryCode"]
		countryName <-- json["data.countryName"]
		email <-- json["data.email"]
		status <-- json["data.status"]
	}
}
