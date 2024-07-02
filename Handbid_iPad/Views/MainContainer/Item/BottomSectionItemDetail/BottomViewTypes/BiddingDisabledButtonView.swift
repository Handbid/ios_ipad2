// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BiddingDisabledButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Bidding Disabled")
			}
			// Add more specific UI and logic for BiddingDisabled state
		}
		.padding()
	}
}
