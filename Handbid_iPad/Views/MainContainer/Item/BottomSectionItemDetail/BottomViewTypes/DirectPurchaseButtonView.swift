// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DirectPurchaseButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType

	var body: some View {
		VStack {
			if item.itemIsAppealAndForSale() {
				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
				}) {
					Text("SUPPORT US")
				}
			}
			else {
				if item.itemStatus != .open, item.itemStatus != .open, item.itemStatus != .open, !(item.isHidden ?? false) {
					Text("Item is not available for purchase")
						.fontWeight(.bold)
				}
				else {
					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						resetTimer()
						showPaddleInput = true
					}) {
						Text("BUY NOW FOR \((valueType.doubleValue ?? 1.0) * (item.buyNowPrice ?? 1.0), format: .currency(code: "USD"))")
					}
				}
			}
		}
		.padding()
	}
}
