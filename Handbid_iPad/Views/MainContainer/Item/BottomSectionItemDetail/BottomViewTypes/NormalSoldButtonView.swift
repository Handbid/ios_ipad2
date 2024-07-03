// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NormalSoldButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType

	var body: some View {
		VStack {
			Text("Item has been purchased")
				.fontWeight(.bold)
		}
		.padding()
	}
}
