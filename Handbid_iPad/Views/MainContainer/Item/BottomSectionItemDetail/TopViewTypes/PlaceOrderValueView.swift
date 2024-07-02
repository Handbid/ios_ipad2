// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PlaceOrderValueView: ValueItemViewProtocol {
	@Binding var valueType: ItemValueType
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		ItemValueView(valueType: $valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount)
	}
}
