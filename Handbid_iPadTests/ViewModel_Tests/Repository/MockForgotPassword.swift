// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import NetworkService

class MockResetPasswordRepository: ResetPasswordRepository {
	var resetPasswordCalled = false
	var resetPasswordEmail: String?

	func resetPassword(email: String) -> AnyPublisher<ResetPasswordModel, Error> {
		resetPasswordCalled = true
		resetPasswordEmail = email
		return Empty<ResetPasswordModel, Error>().eraseToAnyPublisher()
	}
}
