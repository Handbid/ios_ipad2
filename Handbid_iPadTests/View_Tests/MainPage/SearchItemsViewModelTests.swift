// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class SearchItemsViewModelTests: XCTestCase {
	var viewModel: SearchItemsViewModel!
	var repository: MockSearchItemsRepository!
	var cancellables: Set<AnyCancellable> = []

	override func setUp() {
		super.setUp()
		repository = MockSearchItemsRepository()
		viewModel = SearchItemsViewModel(repository: repository)
	}

	func testSearchTextFiltering() {
		let item1 = ItemModel(name: "Test Item One", buyNowPrice: 100, itemStatus: .open, itemType: .buyNow)
		let item2 = ItemModel(name: "Another Test Item", buyNowPrice: 150, itemStatus: .open, itemType: .buyNow)
		viewModel.items = [item1, item2]

		viewModel.searchText = "Test"

		let expectation = XCTestExpectation(description: "Filter items by search text")

		viewModel.$filteredItems
			.sink { filteredItems in
				if filteredItems.count == 2 {
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)

		viewModel.search()

		wait(for: [expectation], timeout: 1.0)

		XCTAssertEqual(viewModel.filteredItems.count, 2)
		XCTAssertTrue(viewModel.filteredItems.contains { $0.name == item1.name })
		XCTAssertTrue(viewModel.filteredItems.contains { $0.name == item2.name })
	}

	func testAddToSearchHistory() {
		viewModel.addToSearchHistory("item1")
		viewModel.addToSearchHistory("item2")
		viewModel.addToSearchHistory("item3")
		viewModel.addToSearchHistory("item4")

		viewModel.addToSearchHistory("item1")
		XCTAssertEqual(viewModel.searchHistory.count, 4)
		XCTAssertEqual(viewModel.searchHistory, ["item1", "item4", "item3", "item2"])
	}

	func testFetchItemsFromRepository() {
		let expectation = expectation(description: "Fetch items")
		repository.mockItems = [ItemModel(name: "Mock Item", buyNowPrice: 50, itemStatus: .open, itemType: .buyNow)]

		viewModel.fetchItemsFromRepository()

		viewModel.$filteredItems
			.dropFirst()
			.sink { items in
				XCTAssertEqual(items.count, 1)
				XCTAssertEqual(items.first?.name, "Mock Item")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		waitForExpectations(timeout: 1, handler: nil)
	}
}

class MockSearchItemsRepository: SearchItemsRepository {
	var mockItems: [ItemModel] = []

	func getSearchItems(name _: String) -> AnyPublisher<[ItemModel], Error> {
		Just(mockItems)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}
