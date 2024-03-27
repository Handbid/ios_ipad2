// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BaseLabelModifier: ViewModifier {
	var textColor: Color
	var font: Font
	var fontWeight: Font.Weight

	func body(content: Content) -> some View {
		content
			.font(font)
			.fontWeight(fontWeight)
			.foregroundStyle(textColor)
	}
}
