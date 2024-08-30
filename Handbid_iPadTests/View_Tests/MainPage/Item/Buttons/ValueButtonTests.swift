// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ValueButtonTests: XCTestCase {
	func testValueButtonLabel() throws {
		let action = {}
		let view = ValueButton(action: action, label: "Test Label")

		let text = try view.inspect().find(text: "Test Label")
		XCTAssertEqual(try text.string(), "Test Label")
	}

	func testValueButtonAction() throws {
		var actionCalled = false
		let action = { actionCalled = true }
		let view = ValueButton(action: action, label: "Test Label")

		try view.inspect().find(button: "Test Label").tap()
		XCTAssertTrue(actionCalled)
	}
}
