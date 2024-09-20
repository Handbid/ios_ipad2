// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class PasswordResetConfirmationViewTests: XCTestCase {
	private var view: PasswordResetConfirmationView<RegistrationPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<RegistrationPage, Any?>!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator { _ in AnyView(EmptyView()) }
		view = PasswordResetConfirmationView()
		sut = AnyView(view.environmentObject(coordinator))
	}

	override func tearDown() {
		coordinator = nil
		view = nil
		sut = nil
		super.tearDown()
	}

	func testInitialContent() {
		var inspectionError: Error? = nil

		ViewHosting.host(view: sut)

		do {
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_resetPassword").text()
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_resetLinkByEmail").text()
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "global_btn_ok").button()
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	@MainActor func testButtonClearingNavigationStack() {
		coordinator.navigationStack.append(.resetPasswordConfirmation)

		let expBeforeTap = view.inspection.inspect { view in
			XCTAssertFalse(self.coordinator.navigationStack.isEmpty)

			let button = try view.find(viewWithAccessibilityIdentifier: "global_btn_ok").button()
			try button.tap()
		}

		let expAfterTap = view.inspection.inspect(onReceive: coordinator.$navigationStack) { _ in
			XCTAssert(self.coordinator.navigationStack.isEmpty)
		}

		ViewHosting.host(view: sut)
		wait(for: [expBeforeTap, expAfterTap], timeout: 1, enforceOrder: true)
	}
}
