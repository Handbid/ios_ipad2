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
		viewModel.email = "handbid@test.com"
		viewModel.password = "SecurePassword123@"
		viewModel.logIn()
		XCTAssertTrue(viewModel.isFormValid)
		XCTAssertFalse(viewModel.showError)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertFalse(mockRepository.logInCalled)
		XCTAssertFalse(mockAuthManager.loginWithAuthModelCalled)
	}

	func testInvalidEmail() {
		viewModel.email = "invalidemail"
		viewModel.password = "SecurePassword123@"
		viewModel.logIn()
		XCTAssertFalse(viewModel.isFormValid)
		XCTAssertFalse(viewModel.showError)
		XCTAssertEqual(viewModel.errorMessage, "Incorrect Email Format")
		XCTAssertFalse(mockRepository.logInCalled)
		XCTAssertFalse(mockAuthManager.loginWithAuthModelCalled)
	}

	func testInvalidPassword() {
		viewModel.email = "handbid@test.com"
		viewModel.password = "weak"
		viewModel.logIn()
		XCTAssertFalse(viewModel.isFormValid)
		XCTAssertFalse(viewModel.showError)
		XCTAssertEqual(viewModel.errorMessage, "Password Does Not Meet Requirements")
		XCTAssertFalse(mockRepository.logInCalled)
		XCTAssertFalse(mockAuthManager.loginWithAuthModelCalled)
	}
}
