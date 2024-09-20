// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ForgotPasswordViewTests: XCTestCase {
	private var view: ForgotPasswordView<RegistrationPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<RegistrationPage, Any?>!
	private var mockViewModel: MockForgotPasswordViewModel!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator { _ in AnyView(EmptyView()) }
		mockViewModel = MockForgotPasswordViewModel()
		view = ForgotPasswordView(viewModel: mockViewModel)
		sut = AnyView(view.environmentObject(coordinator))
	}

	override func tearDown() {
		coordinator = nil
		mockViewModel = nil
		view = nil
		sut = nil
		super.tearDown()
	}

	func testInitialContent() {
		var inspectionError: Error? = nil

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

	@MainActor func testOnSuccessfulRequestMovesToConfirmation() {
		let exp = view.inspection.inspect(onReceive: coordinator.$navigationStack) { _ in
			let stack = self.coordinator.navigationStack
			XCTAssert(stack.count == 1 && stack[0] == .resetPasswordConfirmation)
		}

		ViewHosting.host(view: sut)

		mockViewModel.requestStatus = .ok

		wait(for: [exp], timeout: 1)
	}

	@MainActor func testErrorDisplayedOnFailedRequest() {
		mockViewModel.errorMessage = "error"

		let exp = view.inspection.inspect(onReceive: mockViewModel.$requestStatus) { v in
			XCTAssertNoThrow(try v.find(text: self.mockViewModel.errorMessage))
		}

		ViewHosting.host(view: sut)

		XCTAssertThrowsError(try sut.inspect().find(text: mockViewModel.errorMessage))

		mockViewModel.requestStatus = .badRequest

		wait(for: [exp], timeout: 1)
	}

	@MainActor func testErrorDisplayedOnInvalidForm() {
		mockViewModel.errorMessage = "error"

		let exp = view.inspection.inspect(onReceive: mockViewModel.$isFormValid) { v in
			XCTAssertNoThrow(try v.find(text: self.mockViewModel.errorMessage))
		}

		ViewHosting.host(view: sut)

		XCTAssertThrowsError(try sut.inspect().find(text: mockViewModel.errorMessage))

		mockViewModel.isFormValid = false

		wait(for: [exp], timeout: 1)
	}

	@MainActor func testRequestResetInvokedOnButtonClick() {
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
