// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ValueTextField: View {
	@Binding var valueType: ItemValueType

	var body: some View {
		switch valueType {
		case let .quantity(value):
			TextField("QTY", value: .constant(Double(value)), format: .number)
				.multilineTextAlignment(.center)
				.accessibilityIdentifier("valueTextField")
				.frame(maxWidth: .infinity, alignment: .center)
				.disabled(true)
				.fontWeight(.bold)
		case .none:
			EmptyView()
		default:
			TextField("", value: bindingForTextField(), format: .currency(code: "USD"))
				.multilineTextAlignment(.center)
				.accessibilityIdentifier("valueTextField")
				.frame(maxWidth: .infinity, alignment: .center)
				.disabled(true)
				.fontWeight(.bold)
		}
	}

	private func bindingForTextField() -> Binding<Double> {
		switch valueType {
		case let .bidAmount(value), let .buyNow(value):
			.constant(value)
		case let .quantity(value):
			.constant(Double(value))
		case .none:
			.constant(0)
		}
	}
}
