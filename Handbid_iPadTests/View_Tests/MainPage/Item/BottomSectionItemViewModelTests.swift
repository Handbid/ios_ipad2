// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

final class BottomSectionItemViewModelTests: XCTestCase {
	func testInitialValueTypeForNormalItem() {
		let item = ItemModel(minimumBidAmount: 50, itemType: .normal)
		let viewModel = BottomSectionItemViewModel(item: item)

		XCTAssertEqual(viewModel.valueType, ItemValueType.bidAmount(50))
	}

	func testInitialValueTypeForBuyNowItem() {
		let item = ItemModel(buyNowPrice: 100, itemType: .buyNow)
		let viewModel = BottomSectionItemViewModel(item: item)

		XCTAssertEqual(viewModel.valueType, ItemValueType.buyNow(100))
	}

	func testInitialValueTypeForPlaceOrderItem() {
		let item = ItemModel(inventoryRemaining: 10, itemType: .placeOrder)
		let viewModel = BottomSectionItemViewModel(item: item)

		XCTAssertEqual(viewModel.valueType, ItemValueType.quantity(10))
	}

	func testInitialValueTypeForBiddingDisabledItem() {
		let item = ItemModel(itemType: .biddingDisabled)
		let viewModel = BottomSectionItemViewModel(item: item)

		XCTAssertEqual(viewModel.valueType, ItemValueType.none)
	}
}
