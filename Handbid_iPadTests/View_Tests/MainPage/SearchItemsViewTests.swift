// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class SearchItemsViewTests: XCTestCase {
	private var viewModel: SearchItemsViewModel!
	private var view: SearchItemsView<MainContainerPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<MainContainerPage, Any?>!
	private var cancellables: Set<AnyCancellable> = []

	override func setUp() {
		super.setUp()
		viewModel = SearchItemsViewModel()
		coordinator = Coordinator<MainContainerPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		view = SearchItemsView(viewModel: viewModel)
		sut = AnyView(view.environmentObject(coordinator))
	}

	func testInitialViewModelState() {
		XCTAssertEqual(viewModel.filteredItems.count, 1)
		XCTAssertEqual(viewModel.filteredItems.first?.name, "Test Item")
		XCTAssertEqual(viewModel.filteredItems.first?.categoryName, "Test")
	}

	func testSearchFunctionality() {
		XCTAssertEqual(viewModel.filteredItems.count, 1)

		viewModel.searchText = "Test"
		viewModel.search()
		XCTAssertEqual(viewModel.filteredItems.count, 1)
		XCTAssertEqual(viewModel.filteredItems.first?.name, "Test Item")

//		viewModel.searchText = "Nonexistent"
//		viewModel.search()
//		XCTAssertEqual(viewModel.filteredItems.count, 0)
	}

	func testSearchItemsViewDisplaysFilteredItems() throws {
		ViewHosting.host(view: sut)

		viewModel.filteredItems = fetchItems()
		viewModel.searchText = "Filtered"
		viewModel.search()

		let scrollView = try sut.inspect().find(viewWithAccessibilityIdentifier: "ItemsScrollView").scrollView()
		let grid = try scrollView.lazyVGrid()

		XCTAssertEqual(grid.count, 1)
//		let item = try grid.view(ItemView.self, 0).actualView()
//		XCTAssertEqual(item.item.name, "Filtered Item")
	}

	func fetchItems() -> [ItemModel] {
		[ItemModel(id: 1, name: "Test Item", categoryName: "Test",
		           isDirectPurchaseItem: true, isTicket: false, isPuzzle: false,
		           isAppeal: false, currentPrice: 20.0, itemCode: "123")]
	}
}
