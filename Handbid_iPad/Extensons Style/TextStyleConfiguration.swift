// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

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
