// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BuyNowButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Buy Now for \(item.buyNowPrice)")
			}
			// Add more specific UI and logic for BuyNow state
		}
		.padding()
	}
}
