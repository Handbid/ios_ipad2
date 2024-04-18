// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockForgotPasswordViewModel: ForgotPasswordViewModel {
	@Published var requestResetPasswordCalled = false

	override func validateEmail() {
		isFormValid = true
	}

	override func requestPasswordReset() {
		requestResetPasswordCalled = true
	}
}
