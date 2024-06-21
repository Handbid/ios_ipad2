// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import ViewInspector
import XCTest

class FilterItemsViewTests: XCTestCase {
	private var view: FiltersItemsView!
	private var mockViewModel: MockAuctionViewModel!

	override func setUp() {
		mockViewModel = MockAuctionViewModel()
		view = FiltersItemsView(viewModel: mockViewModel)
	}

	func testDisplayingCategories() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$categories) { view in
			let container = try? view.find(ViewType.ForEach.self)
			XCTAssertEqual(container?.count, 2)
		}

		ViewHosting.host(view: view)

		mockViewModel.categories = [
			CategoryModel(id: 1, name: "Category 1"),
			CategoryModel(id: 2, name: "Category 2"),
		]

		wait(for: [exp], timeout: 1)
	}

	func testSwitchingToggleAffectsViewModel() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$categories) { view in
			let toggle = try? view.find(ViewType.Toggle.self)
			XCTAssert(self.mockViewModel.categories[0].isVisible)

			try? toggle?.tap()

			XCTAssert(!self.mockViewModel.categories[0].isVisible)
		}

		ViewHosting.host(view: view)

		mockViewModel.categories = [
			CategoryModel(id: 1, name: "Category"),
		]

		wait(for: [exp], timeout: 1)
	}
}
