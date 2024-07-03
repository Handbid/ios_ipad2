// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class ButtonSectionItemFactory {
	static func createButtonView(for item: ItemModel, valueType: Binding<ItemValueType>, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .normal:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .liveAuction:
			AnyView(LiveAuctionButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .biddingDisabled:
			AnyView(BiddingDisabledButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .buyNow:
			AnyView(BuyNowButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .buyNowSoldOut:
			AnyView(BuyNowSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .directPurchaseEventOnly:
			AnyView(DirectPurchaseEventOnlyButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .directPurchase:
			AnyView(DirectPurchaseButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .directPurchaseSoldOut:
			AnyView(DirectPurchaseSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .puzzle:
			AnyView(PuzzleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .forSale:
			AnyView(ForSaleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .normalSold:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		case .none:
			AnyView(DefaultButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType))
		}
	}
}
