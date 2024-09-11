// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import Foundation
import NetworkService
import RecaptchaEnterprise

protocol RegisterRepository {
	func getAppVersion() async throws -> AppVersionModel
	func logIn(username: String, password: String?, pin: String?) async throws -> AuthModel
}

protocol LogInAnonymously {
	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error>
}

class RegisterRepositoryImpl: RegisterRepository, LogInAnonymously, NetworkingService {
	var network: NetworkService.NetworkingClient
	private let reCaptchaRepository = ReCaptchaRepository()

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                         "os": AppInfoProvider.os,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func getAppVersion() async throws -> AppVersionModel {
		try await get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                                   "os": AppInfoProvider.os,
		                                                   "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
			.async()
	}

	func logIn(username: String, password: String?, pin: String?) async throws -> AuthModel {
		let captchaToken = try await reCaptchaRepository.getReCaptchaToken()

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

		return try await post("/auth/login", params: params)
			.tryMap { try AuthModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
			.async()
	}
}
