// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

class AuctionViewTests: XCTestCase {
	private var view: AuctionView!
	private var mockViewModel: MockAuctionViewModel!

	override func setUp() {
		mockViewModel = MockAuctionViewModel()
		view = AuctionView(viewModel: mockViewModel)
	}

	func testInitialContent() {
		var inspectionError: Error? = nil
		ViewHosting.host(view: view)

		do {
			_ = try view.inspect().find(viewWithAccessibilityIdentifier: "AuctionView")
			_ = try view.inspect().find(viewWithAccessibilityIdentifier: "CategoriesList")
			_ = try view.inspect().find(viewWithAccessibilityLabel: "Loading overlay")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testNoItemsDisplayed() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$isLoading) { v in
			XCTAssertNoThrow(try v.find(viewWithAccessibilityIdentifier: "AuctionView"))
			XCTAssertNoThrow(try v.find(viewWithAccessibilityIdentifier: "NoItemsView"))
			XCTAssertThrowsError(try v.find(viewWithAccessibilityLabel: "Loading overlay"))
			XCTAssertThrowsError(try v.find(viewWithAccessibilityIdentifier: "CategoriesList"))
		}

		ViewHosting.host(view: view)
		mockViewModel.isLoading = false

		wait(for: [exp], timeout: 1)
	}

	func testDisplayingCategories() {
		let exp = view.inspection.inspect(onReceive: mockViewModel.$filteredCategories) { v in
			let categories = try? v.find(viewWithAccessibilityIdentifier: "CategoriesList")
			let foreach = try? categories?.find(ViewType.ForEach.self)
			XCTAssertEqual(foreach?.count, 2)

			let category1 = try? foreach?.anyView(0).find(ViewType.ForEach.self)
			let category2 = try? foreach?.anyView(1).find(ViewType.ForEach.self)

			XCTAssertEqual(category1?.count, 3)
			XCTAssertEqual(category2?.count, 1)
		}

		ViewHosting.host(view: view)
		mockViewModel.isLoading = false
		mockViewModel.filteredCategories = [
			CategoryModel(id: 1, items: [
				ItemModel(id: 1),
				ItemModel(id: 2),
				ItemModel(id: 3),
			]),
			CategoryModel(id: 2, items: [
				ItemModel(id: 3),
			]),
		]

		wait(for: [exp], timeout: 1)
	}
}
