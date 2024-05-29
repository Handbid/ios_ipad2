// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class MyBidsViewModelTests: XCTestCase {
	var dataService: DataServiceWrapper!
	var viewModel: MyBidsViewModel!

	override func setUp() {
		super.setUp()
		dataService = DataServiceWrapper(wrappedService: AuctionDataService())
		viewModel = MyBidsViewModel(dataService: dataService)
	}

	func testTitle() {
		XCTAssertEqual(viewModel.title, "My Bids")
	}

	func testCenterViewData() {
		let centerViewData = viewModel.centerViewData
		XCTAssertEqual(centerViewData.title, "My Bids")
	}
}
