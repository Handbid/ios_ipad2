// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class CoordinatorUITests: XCTestCase {
	let app = XCUIApplication()

	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		app.launch()
	}

	func testNavigationToLogInView() {
		app.buttons["next"].tap()
		XCTAssertTrue(app.staticTexts["HelloWorld2TextView"].exists)
	}

	func testPopToGetStartedView() {
		app.buttons["next"].tap()
		app.buttons["back 1"].tap()
		XCTAssertTrue(app.staticTexts["GetStartedView"].exists)
	}

	func testPopToRootFromLogInView() {
		app.buttons["next"].tap()
		app.buttons["back 2"].tap()
		XCTAssertTrue(app.staticTexts["GetStartedView"].exists)
	}
}
