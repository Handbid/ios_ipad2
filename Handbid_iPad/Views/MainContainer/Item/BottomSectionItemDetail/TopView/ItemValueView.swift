// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ItemValueView: View {
	@Binding var valueType: ItemValueType
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		HStack(spacing: 20) {
			ValueButton(action: decrementValue, label: "-")
			ValueTextField(valueType: $valueType)
			ValueButton(action: incrementValue, label: "+")
		}
		.padding([.trailing, .leading], 20)
	}

	private func incrementValue() {
		switch valueType {
		case let .bidAmount(value):
			valueType = .bidAmount(value + 1.0)
		case let .buyNow(value):
			valueType = .buyNow(value + 1.0)
		case let .quantity(value):
			valueType = .quantity(value + 1)
		}
	}

	private func decrementValue() {
		switch valueType {
		case let .bidAmount(value):
			if value > initialBidAmount {
				valueType = .bidAmount(value - 1.0)
			}
		case let .buyNow(value):
			if value > initialBidAmount {
				valueType = .buyNow(value - 1.0)
			}
		case let .quantity(value):
			if value > 1 {
				valueType = .quantity(value - 1)
			}
		}
	}
}
