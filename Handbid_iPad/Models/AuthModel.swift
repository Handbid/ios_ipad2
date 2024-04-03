// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import Foundation
import NetworkService

enum GrantType: String {
	case password
	case refreshToken = "refresh_token"
}

struct AuthModel: Decodable, Encodable {
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

extension AuthModel: NetworkingService, NetworkingJSONDecodable {
	var network: NetworkingClient {
		NetworkingClient()
	}

	func signIn(username: String, password: String?, pin: String?, captchaToken: String) -> AnyPublisher<AuthModel, Error> {
		var params: Params = ["username": username,
		                      "captchaToken": captchaToken,
		                      "client_id": AppInfoProvider.os,
		                      "client_secret": AppInfoProvider.authClientSecret,
		                      "grant_type": GrantType.password.rawValue,
		                      "captchaKey": AppInfoProvider.captchaKey,
		                      "whitelabelId": AppInfoProvider.whitelabelId]

		if let password {
			params["password"] = password
		}

		if let pin {
			params["pin"] = pin
		}

		return post("/auth/login", params: params)
			.tryMap { try Self.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}
}
