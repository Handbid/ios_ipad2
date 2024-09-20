// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DirectPurchaseButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var body: some View {
		VStack {
			if item.itemIsAppealAndForSale() {
				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					resetTimer()
					showPaddleInput = true
					selectedAction = .donate
				}) {
					Text(LocalizedStringKey("item_btn_supportUs"))
				}
			}
			else {
				if item.itemStatus != .open, item.itemStatus != .open, item.itemStatus != .open, !(item.isHidden ?? false) {
					Text(LocalizedStringKey("item_label_itemNotAvailableForPurchase"))
						.fontWeight(.bold)
				}
				else {
					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						resetTimer()
						showPaddleInput = true
						selectedAction = .directPurchase((valueType.doubleValue ?? 1.0) * (item.buyNowPrice ?? 1.0))
					}) {
						Text("\(String(localized: "item_btn_buyNowFor")) \((valueType.doubleValue ?? 1.0) * (item.buyNowPrice ?? 1.0), format: .currency(code: "\(auction?.currencyCode ?? "")"))")
					}
				}
			}
		}
		.padding()
	}
}
