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
				Text("Item is not available")
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
					selectedAction = .buyNow
				}) {
					Text("BUY NOW FOR \(item.buyNowPrice ?? 1.0, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
				}

				HStack {
					Button<Text>.styled(config: .thirdButtonStyle, action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .setMaxBid
					}) {
						Text("SET MAX BID")
					}

					Button<Text>.styled(config: .thirdButtonStyle, action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .bidNow
					}) {
						Text("BID NOW")
					}
				}
			}
		}
		.padding()
	}
}
