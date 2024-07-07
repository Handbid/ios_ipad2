// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PlaceOrderButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?

	var body: some View {
		VStack {
			if item.itemStatus == .pending {
				Text("Item is not open for bidding")
					.fontWeight(.bold)
			}
			else {
				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .placeOrder
				}) {
					Text("Place Order")
				}
			}
		}
		.padding()
	}
}
