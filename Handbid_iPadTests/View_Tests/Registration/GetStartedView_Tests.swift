// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class GetStartedViewTests: XCTestCase {
	var view: GetStartedView<RegistrationPage>!
	var mockViewModel: MockGetStartedViewModel!
	var coordinator: Coordinator<RegistrationPage, Any?>!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<RegistrationPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		mockViewModel = MockGetStartedViewModel()
		view = GetStartedView(viewModel: mockViewModel)
	}

	override func tearDown() {
		coordinator = nil
		mockViewModel = nil
		view = nil
		super.tearDown()
	}

	private func buttonClickScenario(accessibilityId: String,
	                                 expectation: XCTestExpectation)
	{
		let sut = view.environmentObject(coordinator)

		var inspectionError: Error? = nil

		ViewHosting.host(view: sut)

		do {
			let button = try sut.inspect().find(viewWithAccessibilityIdentifier: accessibilityId).button()
			XCTAssertNoThrow(try button.tap())
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		wait(for: [expectation], timeout: 1)
	}

	func testInitialContent() {
		var inspectionError: Error? = nil
		let sut = view.environmentObject(coordinator)
		ViewHosting.host(view: sut)
		do {
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "AppLogo")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_welcomeHandbid")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_login")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_demoVersion")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_aboutHandbid")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testLongPressOnLogoMovesToChangeEnv() {
		let sut = view.environmentObject(coordinator)

		var inspectionError: Error? = nil
		let expChangeEnv = view.inspection
			.inspect(onReceive: coordinator.$navigationStack) { _ in
				let stack = self.coordinator.navigationStack
				XCTAssert(stack.count == 1 && stack[0] == RegistrationPage.chooseEnvironment)
			}

		ViewHosting.host(view: sut)

		do {
			let logo = try sut.inspect().find(viewWithAccessibilityIdentifier: "AppLogo")
			XCTAssertNoThrow(try logo.callOnLongPressGesture())
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		wait(for: [expChangeEnv], timeout: 1)
	}

	func testPressingLoginButtonMovesToLogin() {
		let expectation = view.inspection
			.inspect(onReceive: coordinator.$navigationStack) { _ in
				let stack = self.coordinator.navigationStack
				XCTAssert(stack.count == 1 && stack[0] == RegistrationPage.logIn)
			}

		buttonClickScenario(accessibilityId: "registration_btn_login",
		                    expectation: expectation)
	}

	func testPressingDemoVersionButtonLogsAnonimously() {
		let expectation = view.inspection
			.inspect(onReceive: mockViewModel.$loggedInAnonymously) { _ in
				XCTAssert(self.mockViewModel.loggedInAnonymously)
			}

		buttonClickScenario(accessibilityId: "registration_btn_demoVersion",
		                    expectation: expectation)
	}

	func testPressingAboutButtonOpensHandbidWebsite() {
		let expectation = view.inspection
			.inspect(onReceive: mockViewModel.$handbidWebsiteOpened) { _ in
				XCTAssert(self.mockViewModel.handbidWebsiteOpened)
			}

		buttonClickScenario(accessibilityId: "registration_btn_aboutHandbid",
		                    expectation: expectation)
	}
}
