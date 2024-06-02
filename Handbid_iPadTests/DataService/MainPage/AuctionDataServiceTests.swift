// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class AuctionDataServiceTests: XCTestCase {
	var dataService: AuctionDataService!

	override func setUp() {
		super.setUp()
		dataService = AuctionDataService()
	}

	func testFetchData() {
		let expectation = expectation(description: "FetchData")

		dataService.fetchData { result in
			if case let .failure(error) = result {
				XCTAssertEqual(error as? AuctionDataService.DataServiceError, .fetchFailed)
			}
			else {
				XCTFail("Expected fetchFailed error")
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1, handler: nil)
	}
}
