// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class PaddleViewModelTests: XCTestCase {
	var viewModel: PaddleViewModel!
	var mockDataServiceWrapper: DataServiceWrapper!
	var cancellables = Set<AnyCancellable>()

	override func setUp() {
		super.setUp()
		let mockDataService = MockDataService()
		mockDataServiceWrapper = DataServiceWrapper(wrappedService: mockDataService)
//		viewModel = PaddleViewModel(dataService: mockDataServiceWrapper)
	}

	override func tearDown() {
		viewModel = nil
		mockDataServiceWrapper = nil
		cancellables.removeAll()
		super.tearDown()
	}

//	func testInitialTitle() {
//		XCTAssertEqual(viewModel.title, "Paddle Number", "Initial title should be 'Paddle Number'")
//	}
//
//	func testCenterViewData() {
//		let expectedCenterViewData = TopBarCenterViewData(type: .title, title: "Paddle Number")
//		XCTAssertEqual(viewModel.centerViewData.title, expectedCenterViewData.title, "Center view data title should match")
//		XCTAssertEqual(viewModel.centerViewData.type, expectedCenterViewData.type, "Center view data type should match")
//	}
//
//	func testInitialActions() {
//		XCTAssertTrue(viewModel.actions.isEmpty, "Initial actions should be empty")
//	}
}
