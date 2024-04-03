// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PinView: View {
	@Binding var pin: String
	var onPinComplete: (String) -> Void
	var onPinInvalid: () -> Void
	var maxLength: Int
	@FocusState private var isFocused: Bool

	var body: some View {
		VStack(spacing: 20) {
			HStack(spacing: 10) {
				ForEach(Array(pin.prefix(maxLength)).indices, id: \.self) { _ in
					Text("*")
						.applyTextStyle(style: .headerTitle)
				}
				if pin.count < maxLength {
					ForEach(0 ..< (maxLength - pin.count), id: \.self) { _ in
						Text("_")
							.applyTextStyle(style: .headerTitle)
					}
				}
			}
			.padding()

			TextField("", text: $pin)
				.keyboardType(.numberPad)
				.foregroundColor(.clear)
				.accentColor(.clear)
				.background(Color.clear)
				.focused($isFocused)
				.ignoresSafeArea(.keyboard, edges: .bottom)
				.padding()
				.onChange(of: pin) { _, newValue in
					if newValue.count > maxLength {
						pin = String(newValue.prefix(maxLength))
					}
					if newValue.count == maxLength {
						if newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
							onPinComplete(newValue)
						}
						else {
							onPinInvalid()
						}
					}
				}
		}
		.onTapGesture {
			isFocused.toggle()
		}
	}
}
