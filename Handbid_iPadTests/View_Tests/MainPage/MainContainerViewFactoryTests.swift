// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class MainContainerViewFactoryTests: XCTestCase {
	private var factory: MainContainerViewFactory!

	override func setUp() {
		super.setUp()
		factory = MainContainerViewFactory()
	}

	override func tearDown() {
		factory = nil
		super.tearDown()
	}

	func testMakeAuctionView() throws {
		let view = factory.makeAuctionView()
		ViewHosting.host(view: view)
		let titleText = try view.inspect().find(viewWithAccessibilityIdentifier: "auctionTitle").text().string()
		XCTAssertEqual(titleText, "Auction Details")
	}

	func testMakePaddleView() throws {
		let view = factory.makePaddleView()
		ViewHosting.host(view: view)
		let titleText = try view.inspect().find(viewWithAccessibilityIdentifier: "paddleTitle").text().string()
		XCTAssertEqual(titleText, "Paddle Number")
	}

	func testMakeLogOutView() throws {
		let view = factory.makeLogOutView()
		ViewHosting.host(view: view)
		let titleText = try view.inspect().find(viewWithAccessibilityIdentifier: "logOutTitle").text().string()
		XCTAssertEqual(titleText, "Logout Details")
	}

	func testMakeManagerView() throws {
		let view = factory.makeManagerView()
		ViewHosting.host(view: view)
		let titleText = try view.inspect().find(viewWithAccessibilityIdentifier: "managerTitle").text().string()
		XCTAssertEqual(titleText, "Manager Details")
	}

	func testMakeMyBidsView() throws {
		let view = factory.makeMyBidsView()
		ViewHosting.host(view: view)
		let titleText = try view.inspect().find(viewWithAccessibilityIdentifier: "myBidsTitle").text().string()
		XCTAssertEqual(titleText, "My Bids")
	}
}
