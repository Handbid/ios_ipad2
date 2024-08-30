// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class DefaultValueViewTests: XCTestCase {
	func testDefaultValueViewContainsItemValueView() throws {
		let item = ItemModel()
		let view = DefaultValueView(item: item, valueType: .constant(.none), resetTimer: {})

		XCTAssertNoThrow(try view.inspect().find(ItemValueView.self))
	}
}
