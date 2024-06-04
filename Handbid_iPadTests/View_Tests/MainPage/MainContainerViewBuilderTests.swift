// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

final class MainContainerViewBuilderTests: XCTestCase {
	func testMainContainerViewBuilder() throws {
		let mockFactory = MockMainContainerProtocolFactory()
		let factory = AnyViewMainContainerFactory(wrappedFactory: mockFactory)

		let auctionView = MainContainerViewBuilder(selectedView: .auction)
			.environmentObject(factory)
		var text = try auctionView.inspect().find(text: "Mock Auction View")
		XCTAssertEqual(try text.string(), "Mock Auction View")

		let paddleView = MainContainerViewBuilder(selectedView: .paddle)
			.environmentObject(factory)
		text = try paddleView.inspect().find(text: "Mock Paddle View")
		XCTAssertEqual(try text.string(), "Mock Paddle View")

		let myBidsView = MainContainerViewBuilder(selectedView: .myBids)
			.environmentObject(factory)
		text = try myBidsView.inspect().find(text: "Mock My Bids View")
		XCTAssertEqual(try text.string(), "Mock My Bids View")

		let managerView = MainContainerViewBuilder(selectedView: .manager)
			.environmentObject(factory)
		text = try managerView.inspect().find(text: "Mock Manager View")
		XCTAssertEqual(try text.string(), "Mock Manager View")

		let logOutView = MainContainerViewBuilder(selectedView: .logout)
			.environmentObject(factory)
		text = try logOutView.inspect().find(text: "Mock Log Out View")
		XCTAssertEqual(try text.string(), "Mock Log Out View")
	}

	func testAnyViewMainContainerFactory() throws {
		let mockFactory = MockMainContainerProtocolFactory()
		let factory = AnyViewMainContainerFactory(wrappedFactory: mockFactory)

		XCTAssertEqual(try factory.makeAuctionView().inspect().find(text: "Mock Auction View").string(), "Mock Auction View")
		XCTAssertEqual(try factory.makePaddleView().inspect().find(text: "Mock Paddle View").string(), "Mock Paddle View")
		XCTAssertEqual(try factory.makeMyBidsView().inspect().find(text: "Mock My Bids View").string(), "Mock My Bids View")
		XCTAssertEqual(try factory.makeManagerView().inspect().find(text: "Mock Manager View").string(), "Mock Manager View")
		XCTAssertEqual(try factory.makeLogOutView().inspect().find(text: "Mock Log Out View").string(), "Mock Log Out View")
	}
}
