// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

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

extension Text {
	@ViewBuilder
	func applyTextStyle(config: TextStyleConfiguration) -> some View {
		font(config.font)
			.fontWeight(config.fontWeight)
			.foregroundColor(config.foregroundColor)
			.multilineTextAlignment(config.alignment)
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
