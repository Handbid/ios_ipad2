// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class TopViewOfBottomSectionItemFactory {
	static func createValueView(for item: ItemModel, valueType: Binding<ItemValueType>, resetTimer: @escaping () -> Void, initialBidAmount: Double) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderValueView(valueType: valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutValueView(valueType: valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		case .normal:
			AnyView(NormalValueView(valueType: valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		default:
			AnyView(DefaultValueView(valueType: valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		}
	}
}
