// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension Text {
	@ViewBuilder
	func applyTextStyle(config: TextStyleConfiguration) -> some View {
		font(config.font)
			.fontWeight(config.fontWeight)
			.foregroundColor(config.foregroundColor)
			.multilineTextAlignment(config.alignment)
	}
}
