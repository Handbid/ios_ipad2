// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService
import RecaptchaEnterprise
import Arrow

protocol RegisterRepository {
	func getAppVersion() -> AnyPublisher<AppVersionModel, Error>
    func logIn(email: String, password: String?, pin: String?) -> AnyPublisher<AuthModel, Error>
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
					self.recaptchaClient = try await Recaptcha.getClient(withSiteKey: AppInfoProvider.captchaKey)
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
		get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                         "os": AppInfoProvider.os,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

	func getAppVersion() -> AnyPublisher<AppVersionModel, Error> {
		get(ApiEndpoints.getAppVersion, params: ["appName": AppInfoProvider.appName,
		                                         "os": AppInfoProvider.os,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try AppVersionModel.decode($0) }
			.eraseToAnyPublisher()
	}

    func logIn(email: String, password: String?, pin: String?) -> AnyPublisher<AuthModel, Error> {
        
        var params: Params = ["username": email,
                              "captchaToken": recaptchaToken,
                              "client_id": AppInfoProvider.os,
                              "client_secret": AppInfoProvider.authClientSecret,
                              "grant_type": GrantType.password.rawValue,
                              "captchaKey": AppInfoProvider.captchaKey,
                              "whitelabelId": AppInfoProvider.whitelabelId]
        
        if let password = password {
            params["password"] = password
        }
        
        if let pin = pin {
            params["pin"] = pin
        }
        
        return post(ApiEndpoints.logInUser, params: params)
            .tryMap { try AuthModel.decode($0) }
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
