// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension Text {
	func applyTextStyle(style: TextLabelStyles) -> some View {
		applyTextStyle(style: TextLabelStyles.style(for: style))
	}

	@ViewBuilder
	private func applyTextStyle(style: TextStyleConfiguration) -> some View {
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
            .fixedSize(horizontal: style.fixedSizeHorizontal, vertical: style.fixedSizeVertical)
		textField
	}
}
