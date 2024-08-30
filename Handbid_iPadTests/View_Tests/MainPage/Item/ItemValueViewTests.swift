// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ItemValueViewTests: XCTestCase {
	func testIncrementBidAmount() throws {
		var valueType = ItemValueType.bidAmount(100.0)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(bidIncrement: 10, minimumBidAmount: 50)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "+" i naciśnij go
		let incrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "+" })
		try incrementButton.tap()

		XCTAssertEqual(valueType, .bidAmount(110.0))
	}

	func testDecrementBidAmount() throws {
		var valueType = ItemValueType.bidAmount(100.0)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(bidIncrement: 10, minimumBidAmount: 50)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "-" i naciśnij go
		let decrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "-" })
		try decrementButton.tap()

		XCTAssertEqual(valueType, .bidAmount(90.0))
	}

	func testIncrementBuyNowValue() throws {
		var valueType = ItemValueType.buyNow(100.0)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel()
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "+" i naciśnij go
		let incrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "+" })
		try incrementButton.tap()

		XCTAssertEqual(valueType, .buyNow(101.0))
	}

	func testDecrementBuyNowValue() throws {
		var valueType = ItemValueType.buyNow(100.0)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(buyNowPrice: 50)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "-" i naciśnij go
		let decrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "-" })
		try decrementButton.tap()

		XCTAssertEqual(valueType, .buyNow(99.0))
	}

	func testIncrementQuantity() throws {
		var valueType = ItemValueType.quantity(10)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(inventoryRemaining: 10)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "+" i naciśnij go
		let incrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "+" })
		try incrementButton.tap()

		XCTAssertEqual(valueType, .quantity(11))
	}

	func testDecrementQuantity() throws {
		var valueType = ItemValueType.quantity(10)

		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(inventoryRemaining: 10)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		let incrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "-" })
		try incrementButton.tap()

		XCTAssertEqual(valueType, .quantity(9))
	}

	func testDecrementQuantityDoesNotGoBelowOne() throws {
		var valueType = ItemValueType.quantity(1)
		let bindingValueType = Binding<ItemValueType>(
			get: { valueType },
			set: { valueType = $0 }
		)

		let item = ItemModel(inventoryRemaining: 10)
		let view = ItemValueView(valueType: bindingValueType, resetTimer: {}, item: item)

		// Znajdź przycisk "-" i naciśnij go
		let decrementButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "-" })
		try decrementButton.tap()

		XCTAssertEqual(valueType, .quantity(1))
	}
}
