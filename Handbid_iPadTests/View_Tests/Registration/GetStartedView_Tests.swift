// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class GetStartedViewTests: XCTestCase {
	var mockCoordinator: MockCoordinator<RegistrationPage, Any?>!
	var view: GetStartedView<RegistrationPage>!

	override func setUp() {
		super.setUp()
		mockCoordinator = MockCoordinator<RegistrationPage, Any?>()
		view = GetStartedView<RegistrationPage>()
	}

	override func tearDown() {
		mockCoordinator = nil
		view = nil
		super.tearDown()
	}

	func testInitialContent() {
		var inspectionError: Error? = nil
		let coordinator: Coordinator<RegistrationPage, Any?> = mockCoordinator
		let sut = view.environmentObject(coordinator)
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
}
