// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension TextField {
	@ViewBuilder
	func applyTextFieldStyle(style: TextStyles) -> some View {
		let config = style.configuration
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
