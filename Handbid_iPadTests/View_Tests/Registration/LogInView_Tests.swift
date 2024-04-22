// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class LogInViewTests: XCTestCase {
	private var view: LogInView<RegistrationPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<RegistrationPage, Any?>!
	private var mockViewModel: MockLogInViewModel!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<RegistrationPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		mockViewModel = MockLogInViewModel()
		view = LogInView(viewModel: mockViewModel)
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
		do {
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "AppLogo")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_login")
			_ = try sut.inspect()
				.find(FormField.self, where: { view in try view.actualView().fieldType == Field.email })
			_ = try sut.inspect()
				.find(FormField.self, where: { view in try view.actualView().fieldType == Field.password })
			XCTAssertThrowsError(try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_loginError"))
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_login")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_password")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testLogInCalledOnButtonClick() {
		var inspectionError: Error? = nil

		let exp = view.inspection.inspect(onReceive: mockViewModel.$logInCalled) { _ in
			XCTAssert(self.mockViewModel.logInCalled)
		}

		ViewHosting.host(view: sut)

		do {
			let button = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_login").button()
			XCTAssertNoThrow(try button.tap())
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		wait(for: [exp], timeout: 1)
	}

	func testPressingForgotPasswordButtonMovesToForgotPassword() {
		var inspectionError: Error? = nil

		let exp = view.inspection.inspect(onReceive: coordinator.$navigationStack) { _ in
			XCTAssert(self.coordinator.navigationStack.count == 1 &&
				self.coordinator.navigationStack[0] == RegistrationPage.forgotPassword)
		}

		ViewHosting.host(view: sut)

		do {
			let button = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_password").button()
			XCTAssertNoThrow(try button.tap())
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		wait(for: [exp], timeout: 1)
	}

	func testAlertShowingWhenFieldsInViewModelChange() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$showError) { _ in
			let alert = try self.sut.inspect().find(ViewType.ZStack.self).alert()
			XCTAssertEqual(try alert.message().text().string(), "test")
			try alert.actions().button().tap()
		}

		let exp2 = view.inspection.inspect(onReceive: mockViewModel.$resetErrorMessageCalled) { _ in
			XCTAssert(self.mockViewModel.resetErrorMessageCalled)
		}

		ViewHosting.host(view: sut)

		mockViewModel.errorMessage = "test"
		mockViewModel.showError = true

		wait(for: [exp, exp2], timeout: 1, enforceOrder: true)
	}

	func testErrorShownWhenFormInvalid() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$isFormValid) { _ in
			let error = try self.sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_loginError").text()
			XCTAssertEqual(try error.string(), "test")
		}

		ViewHosting.host(view: sut)

		XCTAssertThrowsError(try sut.inspect()
			.find(viewWithAccessibilityIdentifier: "registration_label_loginError").text())

		mockViewModel.errorMessage = "test"
		mockViewModel.isFormValid = false

		wait(for: [exp], timeout: 1)
	}
}
