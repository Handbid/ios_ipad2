// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PlaceOrderButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	var body: some View {
		VStack {
			if item.itemStatus == .pending {}

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Place Order")
			}
		}
		.padding()
	}
}
