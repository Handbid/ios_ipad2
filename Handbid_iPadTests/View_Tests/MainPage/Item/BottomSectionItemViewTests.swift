// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class BottomSectionItemViewTests: XCTestCase {
	func testValueSectionAccessibilityIdentifier() throws {
		let item = ItemModel(name: "Test Item", itemType: .normal)
		let view = BottomSectionItemView(
			item: item,
			resetTimer: {},
			showPaddleInput: .constant(false),
			valueType: .constant(.none),
			selectedAction: .constant(nil)
		)

		let label = try view.inspect().find(viewWithAccessibilityIdentifier: "valueSection")
		XCTAssertEqual(try label.accessibilityIdentifier(), "valueSection")
	}

	func testButtonSectionAccessibilityIdentifier() throws {
		let item = ItemModel(name: "Test Item", itemType: .normal)
		let view = BottomSectionItemView(
			item: item,
			resetTimer: {},
			showPaddleInput: .constant(false),
			valueType: .constant(.none),
			selectedAction: .constant(nil)
		)

		let buttonSection = try view.inspect().find(viewWithAccessibilityIdentifier: "buttonSection")
		XCTAssertEqual(try buttonSection.accessibilityIdentifier(), "buttonSection")
	}

	func testOnTapGestureCallsResetTimer() throws {
		let item = ItemModel(name: "Test Item", itemType: .normal)
		var resetTimerCalled = false
		let view = BottomSectionItemView(
			item: item,
			resetTimer: { resetTimerCalled = true },
			showPaddleInput: .constant(false),
			valueType: .constant(.none),
			selectedAction: .constant(nil)
		)

		try view.inspect().vStack().callOnTapGesture()
		XCTAssertTrue(resetTimerCalled)
	}
}
