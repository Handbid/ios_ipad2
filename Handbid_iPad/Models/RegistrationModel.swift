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
		firstName <-- json["firstName"]
		lastName <-- json["lastName"]
		phoneNumber <-- json["phoneNumber"]
		username <-- json["username"]
		countryCode <-- json["countryCode"]
		countryName <-- json["countryName"]
		email <-- json["email"]
		status <-- json["status"]
	}
}
