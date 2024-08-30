// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class BiddingDisabledButtonViewTests: XCTestCase {
	func testTextIsDisplayed() throws {
		let item = ItemModel()
		let view = BiddingDisabledButtonView(
			item: item,
			resetTimer: {},
			showPaddleInput: .constant(false),
			valueType: .constant(.none),
			selectedAction: .constant(nil)
		)

		let text = try view.inspect().vStack().text(0).string()
		XCTAssertEqual(text, "Online bidding currently disabled for this item")
	}
}
