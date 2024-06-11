// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockAuthManager: AuthManager {
	var loginWithAuthModelCalled = false
	var shouldReturnSuccess = true

	override func loginWithAuthModel(auth _: AuthModel) async -> Bool {
		loginWithAuthModelCalled = true
		return shouldReturnSuccess
	}
}
