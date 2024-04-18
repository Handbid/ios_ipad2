// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ForgotPasswordViewTests: XCTestCase {
	var coordinator: Coordinator<RegistrationPage, Any?>!
	var mockViewModel: MockForgotPasswordViewModel!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator { _ in AnyView(EmptyView()) }
		mockViewModel = MockForgotPasswordViewModel()
	}

	override func tearDownWithError() throws {
		coordinator = nil
		mockViewModel = nil
	}

	func testInitialContent() {
		var inspectionError: Error? = nil
		let sut = ForgotPasswordView<RegistrationPage>(viewModel: mockViewModel)
			.environmentObject(coordinator)

		ViewHosting.host(view: sut)
		mockViewModel.errorMessage = "test"
		do {
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_forgotPassword").text()
			_ = try sut.inspect()
				.find(FormField.self) { view in try view.actualView().fieldType == Field.email }
			XCTAssertThrowsError(try sut.inspect().find(text: mockViewModel.errorMessage))
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_confirm").button()
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		XCTAssert(coordinator.navigationStack.isEmpty)
	}

	func testOnSuccessfulRequestMovesToConfirmation() {
		let view = ForgotPasswordView<RegistrationPage>(viewModel: mockViewModel)
		let sut = view.environmentObject(coordinator)

		let exp = view.inspection.inspect(onReceive: coordinator.$navigationStack) { _ in
			let stack = self.coordinator.navigationStack
			XCTAssert(stack.count == 1 && stack[0] == .resetPasswordConfirmation)
		}

		ViewHosting.host(view: sut)

		mockViewModel.requestStatus = .successful

		wait(for: [exp], timeout: 1)
	}

	func testErrorDisplayedOnFailedRequest() {
		let view = ForgotPasswordView<RegistrationPage>(viewModel: mockViewModel)
		let sut = view.environmentObject(coordinator)

		mockViewModel.errorMessage = "error"

		let exp = view.inspection.inspect(onReceive: mockViewModel.$requestStatus) { v in
			XCTAssertNoThrow(try v.find(text: self.mockViewModel.errorMessage))
		}

		ViewHosting.host(view: sut)

		XCTAssertThrowsError(try sut.inspect().find(text: mockViewModel.errorMessage))

		mockViewModel.requestStatus = .failed

		wait(for: [exp], timeout: 1)
	}

	func testErrorDisplayedOnInvalidForm() {
		let view = ForgotPasswordView<RegistrationPage>(viewModel: mockViewModel)
		let sut = view.environmentObject(coordinator)

		mockViewModel.errorMessage = "error"

		let exp = view.inspection.inspect(onReceive: mockViewModel.$isFormValid) { v in
			XCTAssertNoThrow(try v.find(text: self.mockViewModel.errorMessage))
		}

		ViewHosting.host(view: sut)

		XCTAssertThrowsError(try sut.inspect().find(text: mockViewModel.errorMessage))

		mockViewModel.isFormValid = false

		wait(for: [exp], timeout: 1)
	}

	func testRequestResetInvokedOnButtonClick() {
		let view = ForgotPasswordView<RegistrationPage>(viewModel: mockViewModel)
		let sut = view.environmentObject(coordinator)

		let expClick = view.inspection.inspect { v in
			let button = try v.find(
				viewWithAccessibilityIdentifier: "registration_btn_confirm"
			).button()

			try button.tap()
		}

		let expIsCalled = view.inspection
			.inspect(onReceive: mockViewModel.$requestResetPasswordCalled) { _ in
				XCTAssert(self.mockViewModel.requestResetPasswordCalled)
			}

		ViewHosting.host(view: sut)

		wait(for: [expClick, expIsCalled], timeout: 1, enforceOrder: true)
	}
}
