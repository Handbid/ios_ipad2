// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class NormalSoldButtonViewTests: XCTestCase {
	func testNormalSoldButtonViewDisplaysCorrectText() throws {
		let item = ItemModel()
		let view = NormalSoldButtonView(item: item, resetTimer: {}, showPaddleInput: .constant(false), valueType: .constant(.none), selectedAction: .constant(nil))

		let text = try view.inspect().find(text: "Item has been purchased")
		XCTAssertEqual(try text.string(), "Item has been purchased")
	}
}
