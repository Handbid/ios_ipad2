// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class ButtonSectionItemFactory {
	static func createButtonView(for item: ItemModel, valueType: Binding<ItemValueType>, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>, selectedAction: Binding<ActionButtonType?>) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .normal:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .liveAuction:
			AnyView(LiveAuctionButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .biddingDisabled:
			AnyView(BiddingDisabledButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .buyNow:
			AnyView(BuyNowButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .buyNowSoldOut:
			AnyView(BuyNowSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .directPurchaseEventOnly:
			AnyView(DirectPurchaseEventOnlyButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .directPurchase:
			AnyView(DirectPurchaseButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .directPurchaseSoldOut:
			AnyView(DirectPurchaseSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .puzzle:
			AnyView(PuzzleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .forSale:
			AnyView(ForSaleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .normalSold:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		case .none:
			AnyView(DefaultButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, valueType: valueType, selectedAction: selectedAction))
		}
	}
}
