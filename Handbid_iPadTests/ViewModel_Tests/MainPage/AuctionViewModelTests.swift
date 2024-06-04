// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

final class AuctionViewModelTests: XCTestCase {
	func testAuctionViewModelInitialization() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())

		XCTAssertEqual(viewModel.title, "Auction Details")
		XCTAssertEqual(viewModel.auctionStatus, "Open")
	}

	func testCenterViewData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())
		let centerViewData = viewModel.centerViewData

		XCTAssertEqual(centerViewData.type, .custom)
		XCTAssertNotNil(centerViewData.customView)
		XCTAssertNil(centerViewData.title)
		XCTAssertNil(centerViewData.image)
	}

	func testActions() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())
		let actions = viewModel.actions

		XCTAssertEqual(actions.count, 3)
		XCTAssertEqual(actions[0].icon, "loupeIcon")
		XCTAssertEqual(actions[1].icon, "filtersIcon")
		XCTAssertEqual(actions[2].icon, "refreshIcon")
	}

	func testSearchData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())
		viewModel.searchData()
	}

	func testRefreshData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())
		viewModel.refreshData()
	}

	func testFilterData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService())
		viewModel.filterData()
	}
}
