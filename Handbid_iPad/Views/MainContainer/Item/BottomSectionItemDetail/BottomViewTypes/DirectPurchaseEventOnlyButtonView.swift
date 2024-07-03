// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DirectPurchaseEventOnlyButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType

	var body: some View {
		VStack {
			Text("Event Only")
				.fontWeight(.bold)
		}
		.padding()
	}
}
