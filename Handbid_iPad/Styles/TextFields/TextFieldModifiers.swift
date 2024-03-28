// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BaseTextFieldStyle: TextFieldStyle {
	var cornerRadius: CGFloat
	var backgroundColor: Color
	var borderColor: Color
	var textColor: Color

	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.fullWidthStyle()
			.padding()
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color(backgroundColor))
					.stroke(Color(borderColor), lineWidth: 1.0)
			)
			.bodyTextStyle()
	}
}

struct TextFieldStyleConfiguration {
	var font: Font
	var fontWeight: Font.Weight
	var foregroundColor: Color
	var alignment: TextAlignment
	var rounded: Bool

	init(
		font: Font = .system(size: 16),
		fontWeight: Font.Weight = .regular,
		foregroundColor: Color = .black,
		alignment: TextAlignment = .center,
		rounded: Bool = false
	) {
		self.font = font
		self.fontWeight = fontWeight
		self.foregroundColor = foregroundColor
		self.alignment = alignment
		self.rounded = rounded
	}
}

extension TextField {
	@ViewBuilder
	func applyTextFieldStyle(config: TextFieldStyleConfiguration) -> some View {
		let textField = font(config.font)
			.fontWeight(config.fontWeight)
			.foregroundColor(config.foregroundColor)
			.multilineTextAlignment(config.alignment)

		if config.rounded {
			textField.textFieldStyle(RoundedBorderTextFieldStyle())
		}
		else {
			textField
		}
	}
}
