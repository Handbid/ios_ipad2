// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import NetworkService

class MockResetPasswordRepository: ResetPasswordRepository {
	var resetPasswordCalled = false
	var resetPasswordEmail: String?
	var shouldReturnError = false
	var response: ResetPasswordModel?

	func resetPassword(email: String) -> AnyPublisher<ResetPasswordModel, Error> {
		resetPasswordCalled = true
		resetPasswordEmail = email

		if shouldReturnError {
			return Fail(error: NetworkingError(status: .badRequest))
				.eraseToAnyPublisher()
		}
		else if let response {
			return Just(response)
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
		else {
			return Empty<ResetPasswordModel, Error>()
				.eraseToAnyPublisher()
		}
	}
}
