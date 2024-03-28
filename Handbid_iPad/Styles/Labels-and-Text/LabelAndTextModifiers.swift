// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BaseLabelModifier: ViewModifier {
	var textColor: Color
	var font: Font
	var fontWeight: Font.Weight
	var toUppercase: Bool

	func body(content: Content) -> some View {
		content
			.textCase(toUppercase ? .uppercase : nil)
			.foregroundStyle(textColor)
			.font(font.weight(fontWeight))
	}
}

struct WrapTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.lineLimit(nil)
			.fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
	}
}

// MARK: Global config for app

class GlobalStyle: ObservableObject {
	var largeTextStyle: TextStyleConfiguration {
		TextStyleConfiguration(
			font: .largeTitle,
			fontWeight: .bold,
			foregroundColor: .black,
			alignment: .center
		)
	}

	var texfField: TextFieldStyleConfiguration {
		TextFieldStyleConfiguration(
			font: .body,
			fontWeight: .medium,
			foregroundColor: .gray,
			alignment: .leading,
			rounded: true
		)
	}

	var secureTexfField: SecureTextFieldStyleConfiguration {
		SecureTextFieldStyleConfiguration(
			font: .body,
			fontWeight: .medium,
			foregroundColor: .gray,
			alignment: .leading,
			rounded: true
		)
	}
}

// MARK: OR extension

extension TextStyleConfiguration {
	static var smallTextStyle: TextStyleConfiguration {
		TextStyleConfiguration(
			font: .caption2,
			fontWeight: .heavy
		)
	}
}

// MARK: - Text

struct TextStyleConfiguration {
	var font: Font
	var fontWeight: Font.Weight
	var foregroundColor: Color
	var alignment: TextAlignment

	init(
		font: Font = .system(size: 16),
		fontWeight: Font.Weight = .regular,
		foregroundColor: Color = .black,
		alignment: TextAlignment = .center
	) {
		self.font = font
		self.fontWeight = fontWeight
		self.foregroundColor = foregroundColor
		self.alignment = alignment
	}
}

extension Text {
	@ViewBuilder
	func applyTextStyle(config: TextStyleConfiguration) -> some View {
		font(config.font)
			.fontWeight(config.fontWeight)
			.foregroundColor(config.foregroundColor)
			.multilineTextAlignment(config.alignment)
	}
}

// MARK: - SecureText

struct SecureTextFieldStyleConfiguration {
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

extension SecureField {
	@ViewBuilder
	func applySecureTextFieldStyle(config: SecureTextFieldStyleConfiguration) -> some View {
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
