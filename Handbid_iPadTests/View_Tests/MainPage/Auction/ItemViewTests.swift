// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

class ItemViewTests: XCTestCase {
	private var view: ItemView!

	func testInitialContent() {
		let item = ItemModel(
			id: 1,
			name: "Test",
			categoryName: "category",
			isDirectPurchaseItem: false,
			isTicket: false,
			isAppeal: false,
			currentPrice: 50,
			bidCount: 13,
			itemCode: "123"
		)

		view = ItemView(item: item, currencyCode: "USD", viewWidth: 337, viewHeight: 397)

		ViewHosting.host(view: view)

		var inspectionError: Error? = nil

		XCTAssertNoThrow(try view.inspect().find(viewWithAccessibilityIdentifier: "ImageLoadingIndicator"))

		do {
			let category = try view.inspect().find(viewWithAccessibilityIdentifier: "CategoryName")
			XCTAssertEqual(try category.text().string(), "category")

			let code = try view.inspect().find(viewWithAccessibilityIdentifier: "ItemCode")
			XCTAssertEqual(try code.text().string(), "#123")

			let bidCount = try view.inspect().find(viewWithAccessibilityIdentifier: "NumberOfBids")
			XCTAssert(try bidCount.text().string().contains("13"))

			let name = try view.inspect().find(viewWithAccessibilityIdentifier: "ItemName")
			XCTAssertEqual(try name.text().string(), "Test")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testForSaleBadge() {
		let item = ItemModel(
			id: 1,
			name: "Test",
			categoryName: "category",
			isDirectPurchaseItem: true,
			isTicket: false,
			isAppeal: false,
			currentPrice: 50,
			bidCount: 13,
			itemCode: "123"
		)

		view = ItemView(item: item, currencyCode: "USD", viewWidth: 337, viewHeight: 397)

		ViewHosting.host(view: view)

		XCTAssertThrowsError(try view.inspect().find(viewWithAccessibilityIdentifier: "NuberOfBids"))
		XCTAssertNoThrow(try view.inspect().find(viewWithAccessibilityIdentifier: "ItemBadge"))
	}

	func testLiveBadge() {
		let item = ItemModel(
			id: 1,
			name: "Test",
			categoryName: "category",
			isDirectPurchaseItem: false,
			isLive: true,
			isTicket: false,
			isAppeal: false,
			currentPrice: 50,
			bidCount: 13,
			itemCode: "123"
		)

		view = ItemView(item: item, currencyCode: "USD", viewWidth: 337, viewHeight: 397)

		ViewHosting.host(view: view)

		XCTAssertThrowsError(try view.inspect().find(viewWithAccessibilityIdentifier: "NuberOfBids"))
		XCTAssertNoThrow(try view.inspect().find(viewWithAccessibilityIdentifier: "ItemBadge"))
	}
}
