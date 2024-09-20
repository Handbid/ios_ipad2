// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import ProgressIndicatorView
import SwiftUI
import ViewInspector
import XCTest

final class LogInViewTests: XCTestCase {
	private var view: LogInView<RegistrationPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<RegistrationPage, Any?>!
	private var mockViewModel: MockLogInViewModel!
	private var loadingView: LoadingView!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<RegistrationPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		mockViewModel = MockLogInViewModel()
		view = LogInView(viewModel: mockViewModel)
		sut = AnyView(view.environmentObject(coordinator))
		loadingView = LoadingView(isVisible: .constant(true))
	}

	override func tearDown() {
		coordinator = nil
		mockViewModel = nil
		view = nil
		sut = nil
		loadingView = nil
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

	@MainActor func testLogInCalledOnButtonClick() {
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

	@MainActor func testPressingForgotPasswordButtonMovesToForgotPassword() {
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

    @MainActor func testAlertShowingWhenFieldsInViewModelChange() {
        let exp = view.inspection.inspect(onReceive: mockViewModel.$showError) { view in
            let alert = try view.find(ViewType.Alert.self)
            try alert.actions().button().tap()
            XCTAssertEqual(try alert.message().text().string(), "test")
        }

        let exp2 = view.inspection.inspect(onReceive: mockViewModel.$resetErrorMessageCalled) { _ in
            XCTAssert(self.mockViewModel.resetErrorMessageCalled)
        }

        ViewHosting.host(view: sut)

        DispatchQueue.main.async {
            self.mockViewModel.errorMessage = "test"
            self.mockViewModel.showError = true
        }

        wait(for: [exp, exp2], timeout: 1, enforceOrder: true)
    }

    @MainActor func testErrorShownWhenFormInvalid() {
        let exp = view.inspection.inspect(onReceive: mockViewModel.$isFormValid) { _ in
            let errorLabel = try self.sut.inspect()
                .find(viewWithAccessibilityIdentifier: "registration_label_loginError").text()
            XCTAssertEqual(try errorLabel.string(), "test")
        }

        ViewHosting.host(view: sut)

        XCTAssertThrowsError(try sut.inspect()
            .find(viewWithAccessibilityIdentifier: "registration_label_loginError").text())

        DispatchQueue.main.async {
            self.mockViewModel.errorMessage = "test"
            self.mockViewModel.isFormValid = false
        }

        wait(for: [exp], timeout: 1)
    }


	func testLoadingViewVisible() {
		ViewHosting.host(view: AnyView(loadingView))
		XCTAssertNoThrow(try loadingView.inspect().find(ProgressIndicatorView.self))
	}

	func testLoadingAnimationTriggered() {
		ViewHosting.host(view: AnyView(loadingView))

		let exp = expectation(description: "Animation triggered")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			XCTAssertTrue(self.loadingView.isVisible)
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}
}
