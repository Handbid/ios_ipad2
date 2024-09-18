// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BuyNowButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var body: some View {
		VStack {
			if item.itemStatus != .open, item.itemStatus != .extended, item.itemStatus != .pending {
				Text(LocalizedStringKey("item_label_itemNotAvailable"))
					.fontWeight(.bold)
					.accessibilityLabel("Item not available")
					.accessibilityHint("This item is not currently available for purchase.")
			}
			else if item.itemStatus == .pending {
				Text("Item is not open for bidding")
					.fontWeight(.bold)
					.accessibilityLabel("Item not open")
					.accessibilityHint("This item is pending and cannot be bid on yet.")
			}
			else {
				Button(action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .buyNow
				}) {
					Text("BUY NOW FOR \(item.buyNowPrice ?? 1.0, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
				}
				.accessibilityLabel("Buy now")
				.accessibilityValue("\(item.buyNowPrice ?? 1.0, format: .currency(code: auction?.currencyCode ?? ""))")
				.accessibilityHint("Double-tap to purchase this item immediately.")

				HStack {
					Button(action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .setMaxBid
					}) {
						Text("SET MAX BID")
					}
					.accessibilityLabel("Set max bid")
					.accessibilityHint("Double-tap to set the maximum bid amount for this item.")

					Button(action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .bidNow
					}) {
						Text("BID NOW")
					}
					.accessibilityLabel("Bid now")
					.accessibilityHint("Double-tap to place a bid on this item.")
				}
			}
		}
		.padding()
	}
}
