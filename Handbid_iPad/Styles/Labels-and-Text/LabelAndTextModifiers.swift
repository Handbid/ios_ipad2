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
