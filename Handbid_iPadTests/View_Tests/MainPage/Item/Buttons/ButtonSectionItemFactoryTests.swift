// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ButtonSectionItemFactoryTests: XCTestCase {
	func testCreateButtonViewForPlaceOrder() throws {
		let item = ItemModel(name: "Test Item", itemStatus: .open, itemType: .placeOrder)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(PlaceOrderButtonView.self))
		XCTAssertNoThrow(try view.inspect().find(button: "Place Order"))
	}

	func testCreateButtonViewForPlaceOrderWhenPending() throws {
		let item = ItemModel(name: "Test Item", itemStatus: .pending, itemType: .placeOrder)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		XCTAssertNoThrow(try view.inspect().find(PlaceOrderButtonView.self))
		XCTAssertNoThrow(try view.inspect().find(text: "Item is not open for bidding"))
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
		XCTAssertNoThrow(try view.inspect().find(text: "Item has been purchased"))
	}

	func testCreateButtonViewForNormalWhenOpen() throws {
		let item = ItemModel(name: "Test Item", itemStatus: .open, itemType: .normal)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(NormalButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(button: "BID NOW"))
		XCTAssertNoThrow(try inspectableView.find(button: "SET MAX BID"))
	}

	func testCreateButtonViewForNormalWhenPending() throws {
		let item = ItemModel(name: "Test Item", itemStatus: .pending, itemType: .normal)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(NormalButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(text: "Item is not open for bidding"))
	}

	func testCreateButtonViewForNormalWhenNotAvailable() throws {
		let item = ItemModel(name: "Test Item", itemStatus: .closing, itemType: .normal)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(NormalButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(text: "Item is not available"))
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
		XCTAssertNoThrow(try view.inspect().find(text: "Live Auction Item"))
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

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(BiddingDisabledButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(text: "Online bidding currently disabled for this item"))
	}

	func testCreateButtonViewForBuyNowWhenOpen() throws {
		let item = ItemModel(name: "Test Item", buyNowPrice: 100, itemStatus: .open, itemType: .buyNow)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()

		let allTexts = inspectableView.findAll(ViewType.Text.self)
		for text in allTexts {
			try print(text.string())
		}

		let buyNowButtonText = try inspectableView.find(ViewType.Button.self).labelView().text().string()
		XCTAssertEqual(buyNowButtonText, "BUY NOW FOR 100.0")
	}

	func testCreateButtonViewForBuyNowWhenPending() throws {
		let item = ItemModel(name: "Test Item", buyNowPrice: 100, itemStatus: .pending, itemType: .buyNow)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(BuyNowButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(text: "Item is not open for bidding"))
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
		XCTAssertNoThrow(try view.inspect().find(text: "Item has been purchased"))
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
		XCTAssertNoThrow(try view.inspect().find(text: "Event Only"))
	}

	func testCreateButtonViewForDirectPurchaseWhenOpen() throws {
		let item = ItemModel(name: "Test Item", buyNowPrice: 150, itemStatus: .open, itemType: .directPurchase)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()

		let allTexts = try inspectableView.findAll(ViewType.Text.self)
		for text in allTexts {
			try print(text.string()) // Wydrukuj wszystkie teksty w konsoli
		}

		let buyNowButtonText = try inspectableView.find(ViewType.Button.self).labelView().text().string()
		XCTAssertEqual(buyNowButtonText, "BUY NOW FOR 150.0")
	}

	func testCreateButtonViewForDirectPurchaseWhenPending() throws {
		let item = ItemModel(name: "Test Item", buyNowPrice: 150, itemStatus: .pending, itemType: .directPurchase)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()
		XCTAssertNoThrow(try inspectableView.find(DirectPurchaseButtonView.self))
		XCTAssertNoThrow(try inspectableView.find(text: "Item is not available for purchase"))
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
		XCTAssertNoThrow(try view.inspect().find(text: "Item has been purchased"))
	}

	func testCreateButtonViewForPuzzle() throws {
		let item = ItemModel(name: "Test Item", buyNowPrice: 25, puzzlePiecesCount: 10, itemType: .puzzle)
		let view = ButtonSectionItemFactory.createButtonView(
			for: item,
			valueType: .constant(.none),
			resetTimer: {},
			showPaddleInput: .constant(false),
			selectedAction: .constant(nil)
		)

		let inspectableView = try view.inspect()

		XCTAssertNoThrow(try inspectableView.find(ViewType.Text.self, where: { try $0.string() == "10" }))

		XCTAssertNoThrow(try inspectableView.find(ViewType.Text.self, where: { try $0.string() == "25.0" }))

		let buttonText = try inspectableView.find(ViewType.Button.self).labelView().text().string()
		XCTAssertEqual(buttonText, "Buy Puzzle Piece for 25.0")
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
