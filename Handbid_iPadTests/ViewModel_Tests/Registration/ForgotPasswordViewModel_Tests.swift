// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class ForgotPasswordViewModelTests: XCTestCase {
	var viewModel: ForgotPasswordViewModel!
	var mockRepository: MockResetPasswordRepository!
	var cancellables = Set<AnyCancellable>()

	override func setUp() {
		super.setUp()
		mockRepository = MockResetPasswordRepository()
		viewModel = ForgotPasswordViewModel(repository: mockRepository)
	}

	override func tearDown() {
		viewModel = nil
		mockRepository = nil
		cancellables.removeAll()
		super.tearDown()
	}

	func testValidateEmail() {
		viewModel.email = "invalidEmail"
		viewModel.validateEmail()

		XCTAssertFalse(viewModel.isFormValid)
		XCTAssertEqual(viewModel.errorMessage, "Incorrect Email Format")

		viewModel.email = "validemail@example.com"
		viewModel.validateEmail()

		XCTAssertTrue(viewModel.isFormValid)
		XCTAssertEqual(viewModel.errorMessage, "Incorrect Email Format")
	}

	func testRequestPasswordReset() {
		let email = "validemail@example.com"
		viewModel.email = email
		viewModel.requestPasswordReset()

		XCTAssertTrue(mockRepository.resetPasswordCalled)
		XCTAssertEqual(mockRepository.resetPasswordEmail, email)
	}
}
