// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension SecureField {
	func applySecuredFieldStyle(style: TextSecuredStyles) -> some View {
		applySecuredFieldStyle(style: TextSecuredStyles.style(for: style))
	}

	@ViewBuilder
	private func applySecuredFieldStyle(style: TextFieldStyleConfiguration) -> some View {
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
