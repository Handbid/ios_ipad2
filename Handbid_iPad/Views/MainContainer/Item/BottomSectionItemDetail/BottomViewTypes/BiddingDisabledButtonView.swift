// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BiddingDisabledButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?

	var body: some View {
		VStack {
			Text("Online bidding currently disabled for this item")
				.fontWeight(.bold)
				.accessibilityLabel("Bidding disabled")
		}
		.padding()
	}
}