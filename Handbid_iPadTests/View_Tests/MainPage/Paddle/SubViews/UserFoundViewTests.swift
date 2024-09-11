// Copyright (c) 2024 by Handbid. All rights reserved.

import ViewInspector
import XCTest

@testable import Handbid_iPad

class UserFoundViewTests: XCTestCase {
	private var view: UserFoundView!
	private var mockViewModel: MockPaddleViewModel!
	private let data = RegistrationModel(
		firstName: "First",
		lastName: "Last",
		email: "first.last@test.com"
	)

	override func setUp() {
		mockViewModel = MockPaddleViewModel()
		view = UserFoundView(viewModel: mockViewModel, model: data)
	}

	func testDisplayingData() {
		ViewHosting.host(view: view)

		let nameField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "foundUserName").text()
		let emailField = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "foundUserEmail").text()

		XCTAssertNotNil(nameField)
		XCTAssertNotNil(emailField)

		XCTAssertEqual(try? nameField?.string(), "First Last")
		XCTAssertEqual(try? emailField?.string(), "first.last@test.com")
	}

	func testItsMeButton() {
		ViewHosting.host(view: view)

		let button = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "itsMeButton").button()

		XCTAssertNotNil(button)
		XCTAssertNoThrow(try button?.tap())
		switch mockViewModel.subView {
		case let .confirmInformation(model):
			XCTAssertEqual(model, data)
		default:
			XCTFail("Tapping button didn't change subView value")
		}
	}

	func testNotMeButton() {
		ViewHosting.host(view: view)

		let button = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "notMeButton").button()

		XCTAssertNotNil(button)
		XCTAssertNoThrow(try button?.tap())
		switch mockViewModel.subView {
		case .findPaddle:
			break
		default:
			XCTFail("Tapping button didn't change subView value")
		}
	}
}
