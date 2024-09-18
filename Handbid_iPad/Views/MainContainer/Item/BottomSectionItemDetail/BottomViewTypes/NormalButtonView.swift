// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NormalButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?

	var body: some View {
		VStack {
			if item.itemStatus != .open, item.itemStatus != .extended, item.itemStatus != .pending {
                Text(LocalizedStringKey("item_label_itemNotAvailable"))
					.fontWeight(.bold)
			}
			else if item.itemStatus == .pending {
				Text("Item is not open for bidding")
					.fontWeight(.bold)
			}
			else {
				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .bidNow
				}) {
					Text("BID NOW")
				}

				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .setMaxBid
				}) {
					Text("SET MAX BID")
				}
			}
		}
		.padding()
	}
}
