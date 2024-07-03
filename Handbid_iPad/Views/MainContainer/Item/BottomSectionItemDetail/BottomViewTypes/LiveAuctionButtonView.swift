// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LiveAuctionButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Live Auction")
			}
			Text("\(valueType)")

			// Add more specific UI and logic for LiveAuction state
		}
		.padding()
	}
}
