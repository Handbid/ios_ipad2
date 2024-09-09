// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import ViewInspector
import XCTest

@testable import Handbid_iPad

class CreateAccountViewTests: XCTestCase {
	private var view: CreateAccountView!
	private var mockViewModel: MockPaddleViewModel!

	override func setUp() {
		mockViewModel = MockPaddleViewModel()
		view = CreateAccountView(viewModel: mockViewModel)
	}

	func testInitialContent() {
		mockViewModel.firstName = "Test"
		mockViewModel.lastName = "User"
		mockViewModel.email = "test.user@test.com"
		mockViewModel.phone = "123456789"
		mockViewModel.countryCode = "US"
		mockViewModel.error = ""

		ViewHosting.host(view: view)

		let firstNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountFirstNameField")
			.view(FormField.self)
			.find(ViewType.TextField.self)
		let lastNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountLastNameField")
			.view(FormField.self)
			.find(ViewType.TextField.self)
		let errorField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountErrorField")
		let emailField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountEmailField")
			.view(FormField.self)
			.find(ViewType.TextField.self)
		let phoneField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountPhoneField")
			.view(PhoneField.self)

		XCTAssertNotNil(firstNameField)
		XCTAssertNotNil(lastNameField)
		XCTAssertNil(errorField)
		XCTAssertNotNil(emailField)
		XCTAssertNotNil(phoneField)

		XCTAssertEqual(try? firstNameField?.input(), "Test")
		XCTAssertEqual(try? lastNameField?.input(), "User")
		XCTAssertEqual(try? emailField?.input(), "test.user@test.com")

		XCTAssertEqual(try? phoneField?.actualView().selectedCountryCode, "US")
		XCTAssertEqual(try? phoneField?.actualView().fieldValue, "123456789")
	}

	func testDisplayingError() {
		mockViewModel.error = "Test error"

		ViewHosting.host(view: view)

		let errorField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountErrorField")
			.text()

		XCTAssertNotNil(errorField)
		XCTAssertEqual(try? errorField?.string(), "Test error")
	}

	func testCreateAccountButton() {
		ViewHosting.host(view: view)

		let createAccountButton = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountButton")
			.button()

		XCTAssertNotNil(createAccountButton)
		XCTAssertNoThrow(try createAccountButton?.tap())
		XCTAssertTrue(mockViewModel.wasRegisterNewUserCalled)
	}

	func testBackButton() {
		ViewHosting.host(view: view)

		let backButton = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "createAccountBackButton")
			.button()

		XCTAssertNotNil(backButton)
		XCTAssertNoThrow(try backButton?.tap())

		switch mockViewModel.subView {
		case .findPaddle:
			break
		default:
			XCTFail()
		}
	}
}
