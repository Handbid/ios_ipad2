// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

final class MainContainerViewBuilderTests: XCTestCase {
	func testMainContainerViewBuilder() throws {
		let mockAuctionViewModel = MockAuctionViewModel()
		let mockPaddleViewModel = MockPaddleViewModel()
		let mockMyBidsViewModel = MockMyBidsViewModel()
		let mockManagerViewModel = MockManagerViewModel()
		let mockLogOutViewModel = MockLogOutViewModel()

		let auctionView = MainContainerViewBuilder(selectedView: .auction,
		                                           auctionViewModel: mockAuctionViewModel,
		                                           paddleViewModel: mockPaddleViewModel,
		                                           myBidsViewModel: mockMyBidsViewModel,
		                                           managerViewModel: mockManagerViewModel,
		                                           logOutViewModel: mockLogOutViewModel)
		XCTAssertNoThrow(try auctionView.inspect()
			.find(viewWithAccessibilityIdentifier: "AuctionView"))

		let paddleView = MainContainerViewBuilder(selectedView: .paddle,
		                                          auctionViewModel: mockAuctionViewModel,
		                                          paddleViewModel: mockPaddleViewModel,
		                                          myBidsViewModel: mockMyBidsViewModel,
		                                          managerViewModel: mockManagerViewModel,
		                                          logOutViewModel: mockLogOutViewModel)
		var text = try paddleView.inspect().find(text: "Mock Paddle View")
		XCTAssertEqual(try text.string(), "Mock Paddle View")

		let myBidsView = MainContainerViewBuilder(selectedView: .myBids,
		                                          auctionViewModel: mockAuctionViewModel,
		                                          paddleViewModel: mockPaddleViewModel,
		                                          myBidsViewModel: mockMyBidsViewModel,
		                                          managerViewModel: mockManagerViewModel,
		                                          logOutViewModel: mockLogOutViewModel)
		text = try myBidsView.inspect().find(text: "Mock My Bids View")
		XCTAssertEqual(try text.string(), "Mock My Bids View")

		let managerView = MainContainerViewBuilder(selectedView: .manager,
		                                           auctionViewModel: mockAuctionViewModel,
		                                           paddleViewModel: mockPaddleViewModel,
		                                           myBidsViewModel: mockMyBidsViewModel,
		                                           managerViewModel: mockManagerViewModel,
		                                           logOutViewModel: mockLogOutViewModel)
		text = try managerView.inspect().find(text: "Mock Manager View")
		XCTAssertEqual(try text.string(), "Mock Manager View")

		let logOutView = MainContainerViewBuilder(selectedView: .logout,
		                                          auctionViewModel: mockAuctionViewModel,
		                                          paddleViewModel: mockPaddleViewModel,
		                                          myBidsViewModel: mockMyBidsViewModel,
		                                          managerViewModel: mockManagerViewModel,
		                                          logOutViewModel: mockLogOutViewModel)
		text = try logOutView.inspect().find(text: "Mock Log Out View")
		XCTAssertEqual(try text.string(), "Mock Log Out View")
	}
}
