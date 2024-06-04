// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

class SelectAuctionTopBarCenterViewTests: XCTestCase {
	func testViewContent() throws {
		let view = SelectAuctionTopBarCenterView(title: "Test Title", countAuctions: 5)
		let text = try view.inspect().vStack().text(0).string()
		XCTAssertEqual(text, "Test Title")
	}
}
