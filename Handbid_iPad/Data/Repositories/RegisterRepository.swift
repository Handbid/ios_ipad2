// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

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
		Task {
			do {
				let client = try await Recaptcha.getClient(withSiteKey: ApiConstants.recaptchaKey)
				self.recaptchaClient = client
				getRecaptchaToken()
			}
			catch let error as RecaptchaError {
				print("RecaptchaClient creation error: \(String(describing: error.errorMessage)).")
			}
		}
	}

	private func getRecaptchaToken() {
		Task {
			guard let recaptchaClient = self.recaptchaClient else {
				print("Client not initialized correctly.")
				return
			}

			do {
				let token = try await recaptchaClient.execute(withAction: RecaptchaAction.login)
				self.recaptchaToken = token
			}
			catch let error as RecaptchaError {
				print(error.errorMessage ?? "Unknown error on fetching reCaptcha token")
			}
		}
	}

	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiConstants.GET_APP_VERSION, params: ["appName": AppInfoProvider.appName,
		                                           "os": AppInfoProvider.os,
		                                           "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func getAppVersion() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiConstants.GET_APP_VERSION, params: ["appName": AppInfoProvider.appName,
		                                           "os": AppInfoProvider.os,
		                                           "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func logIn(email: String, password: String) -> AnyPublisher<Any, Error> {
		post(ApiConstants.LOG_IN_USER, params: ["username": email,
		                                        "password": password,
		                                        "grant_type": "password",
		                                        "client_id": AppInfoProvider.os,
		                                        "client_secret": ApiConstants.clientSecret,
		                                        "captchaKey": ApiConstants.recaptchaKey,
		                                        "captchaToken": recaptchaToken,
		                                        "whitelabelId": AppInfoProvider.whitelabelId])
	}
}
