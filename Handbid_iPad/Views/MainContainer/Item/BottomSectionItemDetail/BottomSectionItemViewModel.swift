// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

class BottomSectionItemViewModel: ObservableObject {
	@Published var valueType: ItemValueType
	var item: ItemModel

	init(item: ItemModel) {
		self.item = item
		self.valueType = .none
		setInitialValueType()
	}

	private func setInitialValueType() {
		switch item.itemType {
		case .biddingDisabled:
			valueType = .none
		case .buyNow:
			valueType = .buyNow(item.buyNowPrice ?? 0)
		case .placeOrder:
			valueType = .quantity(item.inventoryRemaining ?? 0)
		case .placeOrderSoldOut:
			valueType = .none
		case .normal:
			valueType = .bidAmount(item.minimumBidAmount ?? 0)
		case .normalSold:
			valueType = .none
		case .buyNowSoldOut:
			valueType = .none
		case .liveAuction:
			valueType = .none
		case .directPurchaseEventOnly:
			valueType = .none
		case .directPurchase:
			valueType = .buyNow(item.buyNowPrice ?? 0)
		case .directPurchaseSoldOut:
			valueType = .none
		case .puzzle:
			valueType = .buyNow(item.buyNowPrice ?? 0)
		case .forSale:
			valueType = .buyNow(item.buyNowPrice ?? 0)
		case .none:
			valueType = .none
		}
	}
}
