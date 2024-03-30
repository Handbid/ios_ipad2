// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

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
