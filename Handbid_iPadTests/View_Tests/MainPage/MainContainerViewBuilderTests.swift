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
		XCTAssertNoThrow(try paddleView.inspect()
			.find(viewWithAccessibilityIdentifier: "PaddleView"))

		let myBidsView = MainContainerViewBuilder(selectedView: .myBids,
		                                          auctionViewModel: mockAuctionViewModel,
		                                          paddleViewModel: mockPaddleViewModel,
		                                          myBidsViewModel: mockMyBidsViewModel,
		                                          managerViewModel: mockManagerViewModel,
		                                          logOutViewModel: mockLogOutViewModel)
		XCTAssertNoThrow(try myBidsView.inspect()
			.find(viewWithAccessibilityIdentifier: "MyBidsView"))

		let managerView = MainContainerViewBuilder(selectedView: .manager,
		                                           auctionViewModel: mockAuctionViewModel,
		                                           paddleViewModel: mockPaddleViewModel,
		                                           myBidsViewModel: mockMyBidsViewModel,
		                                           managerViewModel: mockManagerViewModel,
		                                           logOutViewModel: mockLogOutViewModel)
		XCTAssertNoThrow(try managerView.inspect()
			.find(viewWithAccessibilityIdentifier: "ManagerView"))

		let logOutView = MainContainerViewBuilder(selectedView: .logout,
		                                          auctionViewModel: mockAuctionViewModel,
		                                          paddleViewModel: mockPaddleViewModel,
		                                          myBidsViewModel: mockMyBidsViewModel,
		                                          managerViewModel: mockManagerViewModel,
		                                          logOutViewModel: mockLogOutViewModel)
		XCTAssertNoThrow(try logOutView.inspect()
			.find(viewWithAccessibilityIdentifier: "LogOutView"))
	}
}
