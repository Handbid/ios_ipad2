// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class CenteredViewTests: XCTestCase {
	func testCenteredViewHasCorrectAccessibilityIdentifier() throws {
		let contentView = Text("Center Content")
		let view = CenteredView(view: contentView)

		let centeredView = try view.inspect().find(viewWithAccessibilityIdentifier: "CenteredView")
		XCTAssertEqual(try centeredView.accessibilityIdentifier(), "CenteredView")
	}

	func testCenteredViewContainsCorrectContent() throws {
		let contentView = Text("Center Content")
		let view = CenteredView(view: contentView)

		let centeredContent = try view.inspect().hStack().text(1)
		XCTAssertEqual(try centeredContent.string(), "Center Content")
	}
}
