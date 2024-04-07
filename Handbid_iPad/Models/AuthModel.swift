// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

enum GrantType: String {
	case password
	case refreshToken = "refresh_token"
}

struct AuthModel: Decodable, NetworkingJSONDecodable {
	var token: String?
	var accessToken: String?
	var expiresIn: Int?
	var tokenType: String?
	var refreshToken: String?
	var currentPaddleNumber: String?
	var username: String?
	var identity: Int?
	var guid: String?
	var role: String?
	var authenticatedTwice: Bool?
	var phoneLastFourDigit: String?
	var countryCode: String?
	var isPasswordExpired: Bool?
	var oneTimePassword: Int?

	enum CodingKeys: String, CodingKey {
		case token
		case accessToken = "access_token"
		case expiresIn = "expires_in"
		case tokenType = "token_type"
		case refreshToken = "refresh_token"
		case currentPaddleNumber, username, identity, guid, role, authenticatedTwice, phoneLastFourDigit, countryCode, isPasswordExpired, oneTimePassword
	}
}

extension AuthModel: ArrowParsable {
	init(json: [String: Any]) {
		self.token = json["data.token"] as? String
		self.accessToken = json["data.access_token"] as? String
		self.expiresIn = json["data.expires_in"] as? Int
		self.tokenType = json["data.token_type"] as? String
		self.refreshToken = json["data.refresh_token"] as? String
		self.currentPaddleNumber = json["data.currentPaddleNumber"] as? String
		self.username = json["data.username"] as? String
		self.identity = json["data.identity"] as? Int
		self.guid = json["data.guid"] as? String
		self.role = json["data.role"] as? String
		self.authenticatedTwice = json["data.authenticatedTwice"] as? Bool
		self.phoneLastFourDigit = json["data.phoneLastFourDigit"] as? String
		self.countryCode = json["data.countryCode"] as? String
		self.isPasswordExpired = json["data.isPasswordExpired"] as? Bool
		self.oneTimePassword = json["data.oneTimePassword"] as? Int
	}

	mutating func deserialize(_ json: JSON) {
		token <-- json["data.token"]
		accessToken <-- json["data.access_token"]
		expiresIn <-- json["data.expires_in"]
		tokenType <-- json["data.token_type"]
		refreshToken <-- json["data.refresh_token"]
		currentPaddleNumber <-- json["data.currentPaddleNumber"]
		username <-- json["data.username"]
		identity <-- json["data.identity"]
		guid <-- json["data.guid"]
		role <-- json["data.role"]
		authenticatedTwice <-- json["data.authenticatedTwice"]
		phoneLastFourDigit <-- json["data.phoneLastFourDigit"]
		countryCode <-- json["data.countryCode"]
		isPasswordExpired <-- json["data.isPasswordExpired"]
		oneTimePassword <-- json["data.oneTimePassword"]
	}
}
