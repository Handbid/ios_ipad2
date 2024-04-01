// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService
import RecaptchaEnterprise

protocol RegisterRepository {
	func getAppVersion() -> AnyPublisher<AppVersionModel, Error>
	func logIn(email: String, password: String) -> AnyPublisher<Any, Error>
}

protocol LogInAnonymously {
	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error>
}

class RegisterRepositoryImpl: RegisterRepository, LogInAnonymously, NetworkingService {
	var network: NetworkService.NetworkingClient
	private var recaptchaClient: RecaptchaClient?
	private var recaptchaToken = ""

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	private func executeRecaptcha(withAction _: RecaptchaAction) -> AnyPublisher<Void, Error> {
		Future { promise in
			Task {
				do {
					self.recaptchaClient = try await Recaptcha.getClient(withSiteKey: ApiConstants.clientSecret)
					promise(.success(()))
				}
				catch {
					promise(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
	}

	private func getRecaptchaToken() -> AnyPublisher<String, Error> {
		guard let recaptchaClient else {
			return Fail(error: NSError(domain: "RecaptchaClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "RecaptchaClient is nil"]))
				.eraseToAnyPublisher()
		}

		return Future { promise in
			Task {
				do {
					let token = try await recaptchaClient.execute(withAction: RecaptchaAction.login)
					promise(.success(token))
				}
				catch {
					promise(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
	}

	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiConstants.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                         "os": AppInfoProvider.os,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func getAppVersion() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiConstants.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                         "os": AppInfoProvider.os,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func logIn(email: String, password: String) -> AnyPublisher<Any, Error> {
		executeRecaptcha(withAction: RecaptchaAction.login)
			.flatMap { _ in
				self.getRecaptchaToken()
			}
			.flatMap { recaptchaToken -> AnyPublisher<Any, Error> in
				self.get(ApiConstants.logInUser, params: ["username": email,
				                                          "password": password,
				                                          "grant_type": "password",
				                                          "client_id": AppInfoProvider.os,
				                                          "client_secret": ApiConstants.clientSecret,
				                                          "captchaKey": ApiConstants.recaptchaKey,
				                                          "captchaToken": recaptchaToken,
				                                          "whitelabelId": AppInfoProvider.whitelabelId])
			}
			.eraseToAnyPublisher()
	}
}
