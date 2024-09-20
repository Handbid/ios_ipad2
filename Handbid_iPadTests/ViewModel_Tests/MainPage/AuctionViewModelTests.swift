// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import SwiftUI
import XCTest

final class AuctionViewModelTests: XCTestCase {
	func testAuctionViewModelInitialization() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())

		XCTAssert(viewModel.categories.isEmpty)
		XCTAssert(viewModel.filteredCategories.isEmpty)
		XCTAssertEqual(viewModel.currencyCode, "")
	}

	func testCenterViewData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())
		let centerViewData = viewModel.centerViewData

		XCTAssertEqual(centerViewData.type, .custom)
		XCTAssertNotNil(centerViewData.customView)
		XCTAssertNil(centerViewData.title)
		XCTAssertNil(centerViewData.image)
	}

	func testActions() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())
		let actions = viewModel.actions

		XCTAssertEqual(actions.count, 3)
		XCTAssertEqual(actions[0].icon, "loupeIcon")
		XCTAssertEqual(actions[1].icon, "filtersIcon")
		XCTAssertEqual(actions[2].icon, "refreshIcon")
	}

	func testSearchData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())
		let exp = expectation(description: "Event for searching items is sent via publisher")
		var cancellables = Set<AnyCancellable>()

		viewModel.eventPublisher.sink { event in
			XCTAssertEqual(event, .searchItems)
			exp.fulfill()
		}.store(in: &cancellables)

		viewModel.searchData()

		wait(for: [exp], timeout: 1)

		cancellables.forEach { $0.cancel() }
	}

	func testRefreshData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())
		viewModel.refreshData()
	}

	func testFilterData() {
		let viewModel = AuctionViewModel(dataService: DataServiceFactory.getService(),
		                                 repository: MockAuctionRepository())
		let exp = expectation(description: "Event for filtering items is sent via publisher")
		var cancellables = Set<AnyCancellable>()

		viewModel.eventPublisher.sink { event in
			XCTAssertEqual(event, .filterItems)
			exp.fulfill()
		}.store(in: &cancellables)

		viewModel.filterData()

		wait(for: [exp], timeout: 1)

		cancellables.forEach { $0.cancel() }
	}
}
