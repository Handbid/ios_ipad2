// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockLogInViewModel: LogInViewModel {
	@Published var logInCalled = false
	@Published var resetErrorMessageCalled = false

	init() {
		super.init(repository: MockRegisterRepository(), authManager: MockAuthManager())
	}

	override func logIn() {
		logInCalled = true
	}

	override func resetErrorMessage() {
		super.resetErrorMessage()
		resetErrorMessageCalled = true
	}
}
