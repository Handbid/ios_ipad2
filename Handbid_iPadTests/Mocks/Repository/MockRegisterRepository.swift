// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

class MockRegisterRepository: RegisterRepository {
	var logInCalled = false
	var shouldThrowError = false

	func getAppVersion() async throws -> Handbid_iPad.AppVersionModel {
		let appVersionModel = AppVersionModel(
			demoModeEnabled: 1,
			id: 1,
			os: "iOS",
			appName: "Handbid",
			minimumVersion: "1.0",
			currentVersion: "2.0"
		)
		return appVersionModel
	}

	func getReCaptchaToken() async throws -> String {
		"token"
	}

	func logIn(username _: String, password _: String?, pin _: String?) async throws -> Handbid_iPad.AuthModel {
		logInCalled = true
		if shouldThrowError {
			throw NSError(domain: "", code: -1, userInfo: nil)
		}
		return AuthModel(token: "mockToken")
	}
}
