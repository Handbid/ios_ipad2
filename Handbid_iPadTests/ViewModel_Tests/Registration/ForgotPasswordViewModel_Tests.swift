// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import NetworkService
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
	}

	func testRequestPasswordResetSuccess() {
		let email = "validemail@example.com"
		viewModel.email = email

		mockRepository.response = ResetPasswordModel(success: true, message: nil)

		let expectation = XCTestExpectation(description: "Password reset request succeeds")

		viewModel.$requestStatus
			.dropFirst()
			.sink { status in
				XCTAssertEqual(status, .ok)
				XCTAssertEqual(self.viewModel.errorMessage, "")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.requestPasswordReset()

		XCTAssertTrue(mockRepository.resetPasswordCalled)
		XCTAssertEqual(mockRepository.resetPasswordEmail, email)

		wait(for: [expectation], timeout: 1.0)
	}

	func testRequestPasswordResetFailure() {
		let email = "validemail@example.com"
		viewModel.email = email

		mockRepository.shouldReturnError = true

		let expectation = XCTestExpectation(description: "Password reset request fails")

		viewModel.$requestStatus
			.dropFirst()
			.sink { status in
				XCTAssertEqual(status, .badRequest)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.requestPasswordReset()

		XCTAssertTrue(mockRepository.resetPasswordCalled)
		XCTAssertEqual(mockRepository.resetPasswordEmail, email)

		wait(for: [expectation], timeout: 1.0)
	}

	func testResetErrorMessage() {
		viewModel.errorMessage = "Test error"
		viewModel.resetErrorMessage()
		XCTAssertEqual(viewModel.errorMessage, "")
	}
}
