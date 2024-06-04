// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class StringExtensionsTests: XCTestCase {
	func testIsValidEmail() {
		XCTAssertTrue("test@example.com".isValidEmail())
		XCTAssertFalse("invalid-email".isValidEmail())
	}

	func testIsPasswordSecure() {
		XCTAssertTrue("password123".isPasswordSecure())
		XCTAssertFalse("short".isPasswordSecure())
	}

	func testIsValidPin() {
		XCTAssertTrue("1234".isValidPin())
		XCTAssertFalse("12".isValidPin())
		XCTAssertFalse("abcd".isValidPin())
	}
}
