// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import ViewInspector
import XCTest

@testable import Handbid_iPad

class FindPaddleViewTests: XCTestCase {
	private var view: FindPadleView!
	private var mockViewModel: MockPaddleViewModel!

	override func setUp() {
		mockViewModel = MockPaddleViewModel()
		view = FindPadleView(viewModel: mockViewModel)
	}

	func testSearchByEmailView() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$pickedMethod) { v in
			let picker = try? v.find(viewWithAccessibilityIdentifier: "findPaddleMethodPicker")
				.view(PickerView<SearchBy, Text>.self)
				.actualView()
			let error = try? v.find(viewWithAccessibilityIdentifier: "findPaddleErrorField")
			let emailForm = try? v.find(viewWithAccessibilityIdentifier: "findPaddleEmailForm")
			let phoneForm = try? v.find(viewWithAccessibilityIdentifier: "findPaddlePhoneForm")

			XCTAssertNotNil(picker)
			XCTAssertEqual(picker?.selection, .email)
			XCTAssertNil(error)
			XCTAssertNotNil(emailForm)
			XCTAssertNil(phoneForm)
		}

		ViewHosting.host(view: view)

		mockViewModel.error = ""
		mockViewModel.pickedMethod = .email

		wait(for: [exp], timeout: 2)
	}

	func testSearchByPhoneView() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$pickedMethod) { v in
			let picker = try? v.find(viewWithAccessibilityIdentifier: "findPaddleMethodPicker")
				.view(PickerView<SearchBy, Text>.self)
				.actualView()
			let error = try? v.find(viewWithAccessibilityIdentifier: "findPaddleErrorField")
			let emailForm = try? v.find(viewWithAccessibilityIdentifier: "findPaddleEmailForm")
			let phoneForm = try? v.find(viewWithAccessibilityIdentifier: "findPaddlePhoneForm")

			XCTAssertNotNil(picker)
			XCTAssertEqual(picker?.selection, .cellPhone)
			XCTAssertNil(error)
			XCTAssertNil(emailForm)
			XCTAssertNotNil(phoneForm)
		}

		ViewHosting.host(view: view)

		mockViewModel.error = ""
		mockViewModel.pickedMethod = .cellPhone

		wait(for: [exp], timeout: 2)
	}

	func testDisplayingError() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$error) { v in
			let error = try? v.find(viewWithAccessibilityIdentifier: "findPaddleErrorField")

			XCTAssertNil(error)

			self.mockViewModel.error = "Test error"
		}

		let exp2 = view.inspection.inspect(onReceive: mockViewModel.$error.dropFirst()) { v in
			let error = try? v.find(viewWithAccessibilityIdentifier: "findPaddleErrorField")

			XCTAssertNotNil(error)
		}

		ViewHosting.host(view: view)

		mockViewModel.error = ""

		wait(for: [exp, exp2], timeout: 2, enforceOrder: true)
	}

	func testContinueButton() {
		ViewHosting.host(view: view)

		let button = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "findPaddleContinueButton").button()

		XCTAssertNotNil(button)
		XCTAssertNoThrow(try button?.tap())
		XCTAssertTrue(mockViewModel.wasRequestFindingPaddleCalled)
	}

	func testCreateAccountButton() {
		ViewHosting.host(view: view)

		let button = try? view.inspect()
			.find(viewWithAccessibilityIdentifier: "findPaddleCreateNewAccountButton").button()

		XCTAssertNotNil(button)
		XCTAssertNoThrow(try button?.tap())
		switch mockViewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail("Tapping button didn't cause change of subview to create account")
		}
	}
}
