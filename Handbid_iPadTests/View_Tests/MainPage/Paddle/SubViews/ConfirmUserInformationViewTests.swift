// Copyright (c) 2024 by Handbid. All rights reserved.

import ViewInspector
import XCTest

@testable import Handbid_iPad

class ConfirmUserInformationViewTests: XCTestCase {
	private var view: ConfirmUserInformationView!
	private var mockViewModel: MockPaddleViewModel!
	private var data: RegistrationModel!

	override func setUp() {
		mockViewModel = MockPaddleViewModel()
	}

	override func tearDown() {
		view = nil
		mockViewModel = nil
		data = nil
	}

	func testDisplayUserData() {
		data = RegistrationModel(
			firstName: "Test",
			lastName: "User",
			phoneNumber: "123456789",
			email: "test.user@email.com",
			currentPaddleNumber: 123,
			currentPlacement: "T2",
			sponsorName: "Test Sponsor"
		)

		view = ConfirmUserInformationView(viewModel: mockViewModel, model: data)

		ViewHosting.host(view: view)

		let firstNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "firstNameField").text()
		let lastNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "lastNameField").text()
		let emailField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "emailField").text()
		let cellPhoneField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "cellPhoneField").text()
		let paddleNumberField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "paddleNumberField").text()
		let tableNumberField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "tableNumberField").text()
		let sponsorField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "sponsorField").text()

		XCTAssertNotNil(firstNameField)
		XCTAssertNotNil(lastNameField)
		XCTAssertNotNil(emailField)
		XCTAssertNotNil(cellPhoneField)
		XCTAssertNotNil(paddleNumberField)
		XCTAssertNotNil(tableNumberField)
		XCTAssertNotNil(sponsorField)

		XCTAssertEqual(try? firstNameField?.string(), "Test")
		XCTAssertEqual(try? lastNameField?.string(), "User")
		XCTAssertEqual(try? emailField?.string(), "test.user@email.com")
		XCTAssertEqual(try? cellPhoneField?.string(), "123456789")
		XCTAssertEqual(try? paddleNumberField?.string(), "123")
		XCTAssertEqual(try? tableNumberField?.string(), "T2")
		XCTAssertEqual(try? sponsorField?.string(), "Test Sponsor")
	}

	func testDisplayingEmptyModel() {
		data = RegistrationModel()

		view = ConfirmUserInformationView(viewModel: mockViewModel, model: data)

		ViewHosting.host(view: view)

		let firstNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "firstNameField").text()
		let lastNameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "lastNameField").text()
		let emailField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "emailField").text()
		let cellPhoneField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "cellPhoneField").text()
		let paddleNumberField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "paddleNumberField").text()
		let tableNumberField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "tableNumberField").text()
		let sponsorField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "sponsorField").text()

		XCTAssertNotNil(firstNameField)
		XCTAssertNotNil(lastNameField)
		XCTAssertNotNil(emailField)
		XCTAssertNotNil(cellPhoneField)
		XCTAssertNotNil(paddleNumberField)
		XCTAssertNotNil(tableNumberField)
		XCTAssertNotNil(sponsorField)

		XCTAssertEqual(try? firstNameField?.string(), "N/A")
		XCTAssertEqual(try? lastNameField?.string(), "N/A")
		XCTAssertEqual(try? emailField?.string(), "N/A")
		XCTAssertEqual(try? cellPhoneField?.string(), "N/A")
		XCTAssertEqual(try? paddleNumberField?.string(), "N/A")
		XCTAssertEqual(try? tableNumberField?.string(), "N/A")
		XCTAssertEqual(try? sponsorField?.string(), "N/A")
	}

	func testConfirmButtonTap() {
		data = RegistrationModel(
			firstName: "Test",
			lastName: "User",
			phoneNumber: "123456789",
			email: "test.user@email.com",
			currentPaddleNumber: 123,
			currentPlacement: "T2",
			sponsorName: "Test Sponsor"
		)

		view = ConfirmUserInformationView(viewModel: mockViewModel, model: data)

		ViewHosting.host(view: view)

		let button = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "confirmButton").button()

		XCTAssertNotNil(button)

		XCTAssertNoThrow(try button?.tap())

		XCTAssertTrue(mockViewModel.wasConfirmFoundUserCalled)
		XCTAssertEqual(mockViewModel.lastConfirmFoundUserModel, data)
	}
}
