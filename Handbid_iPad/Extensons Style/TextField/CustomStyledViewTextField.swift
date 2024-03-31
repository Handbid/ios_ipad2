// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension TextField {
	@ViewBuilder
	func applyTextFieldStyle(style: TextStyleConfiguration) -> some View {
		let textField = font(style.fontStyle)
			.fontWeight(style.fontWeightStyle)
			.foregroundColor(style.defaultTextColor)
			.padding()
			.background(style.backgroundColor)
			.cornerRadius(style.roundedCornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: style.roundedCornerRadius)
					.stroke(style.borderColor, lineWidth: style.borderWidthValue)
			)
			.textFieldStyle(PlainTextFieldStyle())
			.multilineTextAlignment(style.alignment)
			.frame(maxWidth: .infinity)
			.disabled(style.autoCorrectionDisabled)
			.textContentType(style.isSecure ? .password : .none)
			.lineLimit(style.maxCharacterCount)
		textField
	}
}
