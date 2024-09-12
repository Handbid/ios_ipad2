// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class NormalValueViewTests: XCTestCase {
	func testNormalValueViewContainsItemValueView() throws {
		let item = ItemModel()
		let view = NormalValueView(item: item, valueType: .constant(.none), resetTimer: {})

		XCTAssertNoThrow(try view.inspect().find(ItemValueView.self))
	}
}
