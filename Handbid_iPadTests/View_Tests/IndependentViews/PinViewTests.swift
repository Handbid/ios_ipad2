// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

class PinViewTests: XCTestCase {
	func testPinViewComplete() throws {
		let pin = ""
		let onPinComplete: (String) -> Void = { completedPin in
			XCTAssertEqual(completedPin, "1234")
		}
		let onPinInvalid: () -> Void = { XCTFail("Pin should be valid") }
		let view = PinView(pin: .constant(pin), onPinComplete: onPinComplete, onPinInvalid: onPinInvalid, maxLength: 4)

		let sut = try view.inspect()
		try sut.find(ViewType.TextField.self).setInput("1234")
	}
}
