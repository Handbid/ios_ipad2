// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct RegistrationModel: Equatable, Decodable, NetworkingJSONDecodable {
	var firstName: String?
	var lastName: String?
	var phoneNumber: String?
	var username: String?
	var countryCode: String?
	var countryName: String?
	var isCheckedIn: Int?

	var email: String?
	var status: String?

	var currentPaddleNumber: Int?
	var currentPlacement: String?
	var sponsorName: String?

	var success: Bool?
	var errorMessage: String?
}

extension RegistrationModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		firstName <-- json["data.firstName"]
		lastName <-- json["data.lastName"]
		phoneNumber <-- json["data.userCellPhone"]
		username <-- json["data.username"]
		countryCode <-- json["data.countryCode"]
		countryName <-- json["data.countryName"]
		email <-- json["data.email"]
		status <-- json["data.status"]
		currentPaddleNumber <-- json["data.paddleNumber"]
		currentPlacement <-- json["data.currentPlacement"]
		sponsorName <-- json["data.sponsorName"]
		isCheckedIn <-- json["data.isCheckedIn"]

		success <-- json["success"]
		errorMessage <-- json["errorMessage"]
	}
}
