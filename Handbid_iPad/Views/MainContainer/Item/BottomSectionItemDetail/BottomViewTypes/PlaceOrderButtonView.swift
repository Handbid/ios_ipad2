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
				Text(LocalizedStringKey("item_label_notOpenForBidding"))
					.fontWeight(.bold)
			}
			else {
				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .placeOrder
				}) {
					Text(LocalizedStringKey("item_btn_placeOrder"))
				}
			}
		}
		.padding()
	}
}
