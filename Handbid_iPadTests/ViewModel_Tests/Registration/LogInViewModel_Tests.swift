// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class LogInViewModelTests: XCTestCase {
	var viewModel: LogInViewModel!
	var mockRepository: MockRegisterRepository!
	var mockAuthManager: MockAuthManager!

	override func setUp() {
		super.setUp()
		mockRepository = MockRegisterRepository()
		mockAuthManager = MockAuthManager()
		viewModel = LogInViewModel(repository: mockRepository, authManager: mockAuthManager)
	}

	override func tearDown() {
		viewModel = nil
		mockRepository = nil
		mockAuthManager = nil
		super.tearDown()
	}

	func testValidEmailAndPassword() {
		let expectation = expectation(description: "Login")

		viewModel.email = "handbid@test.com"
		viewModel.password = "SecurePassword123@"

		Task {
			viewModel.logIn()
			try await Task.sleep(nanoseconds: 200_000_000)
			XCTAssertTrue(self.viewModel.isFormValid, "Form should be valid with correct email and password")
			XCTAssertFalse(self.viewModel.showError, "showError should be false when the form is valid")
			XCTAssertEqual(self.viewModel.errorMessage, "", "errorMessage should be empty when the form is valid")
			XCTAssertTrue(self.mockRepository.logInCalled)
			XCTAssertTrue(self.mockAuthManager.loginWithAuthModelCalled)
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1.0, handler: nil)
	}

	func testInvalidEmail() {
		viewModel.email = "invalidemail"
		viewModel.password = "SecurePassword123@"
		viewModel.logIn()
		XCTAssertFalse(viewModel.isFormValid)
		XCTAssertFalse(viewModel.showError)
		XCTAssertEqual(viewModel.errorMessage, NSLocalizedString("registration_label_incorrectEmail", comment: "Incorrect Email Format"))
		XCTAssertFalse(mockRepository.logInCalled)
		XCTAssertFalse(mockAuthManager.loginWithAuthModelCalled)
	}

	func testInvalidPassword() {
		viewModel.email = "handbid@test.com"
		viewModel.password = "weak"
		viewModel.logIn()
		XCTAssertFalse(viewModel.isFormValid)
		XCTAssertFalse(viewModel.showError)
		XCTAssertEqual(viewModel.errorMessage, NSLocalizedString("registration_label_passwordRequirements", comment: "Password doesn't meet the requirements"))
		XCTAssertFalse(mockRepository.logInCalled)
		XCTAssertFalse(mockAuthManager.loginWithAuthModelCalled)
	}

	func testLoginFailsWithError() {
		let expectation = expectation(description: "Login fails with error")

		viewModel.email = "handbid@test.com"
		viewModel.password = "SecurePassword123@"
		mockRepository.shouldThrowError = true

		Task {
			viewModel.logIn()
			try await Task.sleep(nanoseconds: 200_000_000)
			XCTAssertTrue(self.viewModel.showError)
			XCTAssertEqual(self.viewModel.errorMessage, NSLocalizedString("login_label_incorrectCredentials", comment: "Incorrect email or password"))
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1.0, handler: nil)
	}

	func testLoginSuccessButAuthManagerFails() {
		let expectation = expectation(description: "Login succeeds but AuthManager fails")

		viewModel.email = "handbid@test.com"
		viewModel.password = "SecurePassword123@"
		mockAuthManager.shouldReturnSuccess = false

		Task {
			viewModel.logIn()
			try await Task.sleep(nanoseconds: 200_000_000)
			XCTAssertTrue(self.viewModel.isFormValid)
			XCTAssertTrue(self.viewModel.showError)
			XCTAssertEqual(self.viewModel.errorMessage, "")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1.0, handler: nil)
	}

	func testLoginSuccessAndAuthManagerSuccessButSaveDataFails() {
		let expectation = expectation(description: "Login and save data fails")

		viewModel.email = "handbid@test.com"
		viewModel.password = "SecurePassword123@"
		mockAuthManager.shouldReturnSuccess = true

		Task {
			viewModel.logIn()
			try await Task.sleep(nanoseconds: 200_000_000)
			XCTAssertTrue(self.viewModel.isFormValid)
			XCTAssertFalse(self.viewModel.showError)

			mockAuthManager.shouldReturnSuccess = false
			viewModel.logIn()
			try await Task.sleep(nanoseconds: 200_000_000)
			XCTAssertTrue(self.viewModel.showError)
			expectation.fulfill()
		}

		waitForExpectations(timeout: 2.0, handler: nil)
	}

	func testResetErrorMessage() {
		viewModel.errorMessage = "Test error"
		viewModel.showError = true
		viewModel.resetErrorMessage()
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertFalse(viewModel.showError)
	}
}
