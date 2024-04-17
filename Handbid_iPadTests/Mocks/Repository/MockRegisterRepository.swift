// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockRegisterRepository: RegisterRepository {
	var logInCalled = false

	func getAppVersion() async throws -> Handbid_iPad.AppVersionModel {
		let json: [String: Any] = [
			"appVersion.id": 1,
			"appVersion.os": "iOS",
			"appVersion.appName": "Handbid",
			"appVersion.minimumVersion": "1.0",
			"appVersion.currentVersion": "2.0",
			"demoModeEnabled": 1,
		]
		logInCalled = true
		return AppVersionModel(json: json)
	}

	func getReCaptchaToken() async throws -> String {
		"token"
	}

	func logIn(username _: String, password _: String?, pin _: String?) async throws -> Handbid_iPad.AuthModel {
		logInCalled = true
		return AuthModel(token: "mockToken")
	}
}
