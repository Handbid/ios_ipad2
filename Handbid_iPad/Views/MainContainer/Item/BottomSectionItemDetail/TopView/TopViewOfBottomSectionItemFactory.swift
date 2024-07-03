// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class TopViewOfBottomSectionItemFactory {
	static func createValueView(for item: ItemModel, valueType: Binding<ItemValueType>, resetTimer: @escaping () -> Void) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderValueView(item: item, valueType: valueType, resetTimer: resetTimer))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutValueView(item: item, valueType: valueType, resetTimer: resetTimer))
		case .normal:
			AnyView(NormalValueView(item: item, valueType: valueType, resetTimer: resetTimer))
		default:
			AnyView(DefaultValueView(item: item, valueType: valueType, resetTimer: resetTimer))
		}
	}
}
