// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ButtonSectionItemFactoryTests: XCTestCase {
	func testCreateButtonViewForPlaceOrder() throws {
		let item = ItemModel(name: "Test Item", itemType: .placeOrder)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(PlaceOrderButtonView.self))
	}

	func testCreateButtonViewForPlaceOrderSoldOut() throws {
		let item = ItemModel(name: "Test Item", itemType: .placeOrderSoldOut)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(PlaceOrderSoldOutButtonView.self))
	}

	func testCreateButtonViewForNormal() throws {
		let item = ItemModel(name: "Test Item", itemType: .normal)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(NormalButtonView.self))
	}

	func testCreateButtonViewForLiveAuction() throws {
		let item = ItemModel(name: "Test Item", itemType: .liveAuction)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(LiveAuctionButtonView.self))
	}

	func testCreateButtonViewForBiddingDisabled() throws {
		let item = ItemModel(name: "Test Item", itemType: .biddingDisabled)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(BiddingDisabledButtonView.self))
	}

	func testCreateButtonViewForBuyNow() throws {
		let item = ItemModel(name: "Test Item", itemType: .buyNow)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(BuyNowButtonView.self))
	}

	func testCreateButtonViewForBuyNowSoldOut() throws {
		let item = ItemModel(name: "Test Item", itemType: .buyNowSoldOut)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(BuyNowSoldOutButtonView.self))
	}

	func testCreateButtonViewForDirectPurchaseEventOnly() throws {
		let item = ItemModel(name: "Test Item", itemType: .directPurchaseEventOnly)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(DirectPurchaseEventOnlyButtonView.self))
	}

	func testCreateButtonViewForDirectPurchase() throws {
		let item = ItemModel(name: "Test Item", itemType: .directPurchase)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(DirectPurchaseButtonView.self))
	}

	func testCreateButtonViewForDirectPurchaseSoldOut() throws {
		let item = ItemModel(name: "Test Item", itemType: .directPurchaseSoldOut)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(DirectPurchaseSoldOutButtonView.self))
	}

	func testCreateButtonViewForPuzzle() throws {
		let item = ItemModel(name: "Test Item", itemType: .puzzle)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(PuzzleButtonView.self))
	}

	func testCreateButtonViewForForSale() throws {
		let item = ItemModel(name: "Test Item", itemType: .forSale)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(ForSaleButtonView.self))
	}

	func testCreateButtonViewForNormalSold() throws {
		let item = ItemModel(name: "Test Item", itemType: .normalSold)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(NormalButtonView.self))
	}

	func testCreateButtonViewForNone() throws {
		let item = ItemModel(name: "Test Item", itemType: .none)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(DefaultButtonView.self))
	}
}
