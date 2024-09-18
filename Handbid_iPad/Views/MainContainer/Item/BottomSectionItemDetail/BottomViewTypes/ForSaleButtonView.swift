// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ForSaleButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?

	var body: some View {
		VStack {
			if item.itemIsAppealAndForSale() {
				Button(action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .donate
				}) {
					Text(LocalizedStringKey("item_btn_supportUs"))
				}
				.accessibilityLabel("Support Us")
				.accessibilityHint("Double-tap to donate and support this cause.")
			}
			else {
				if item.itemStatus != .open, item.itemStatus != .open, item.itemStatus != .open, !(item.isHidden ?? false) {
                    Text(LocalizedStringKey("item_label_itemNotAvailableForPurchase"))
						.fontWeight(.bold)
						.accessibilityLabel("Item not available")
						.accessibilityHint("This item is not currently available for purchase.")
				}
				else {
					Button(action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .buyNow
					}) {
						Text("BUY NOW")
					}
					.accessibilityLabel("Buy Now")
					.accessibilityHint("Double-tap to purchase this item immediately.")
				}
			}
		}
		.padding()
	}
}
