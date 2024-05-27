// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ButtonStyleConfiguration {
	var backgroundColor: Color
	var foregroundColor: Color
	var borderColor: Color?
	var borderWidth: CGFloat
	var cornerRadius: CGFloat
	var font: Font
	var shadowColor: Color?
	var shadowRadius: CGFloat
	var shadowOpacity: Double
	var padding: EdgeInsets
	var spacing: CGFloat
	var icon: Image?
	var disabledColor: Color?
	var hoverEffect: HoverEffect
	var accessibilityLabel: String?

	init(
		backgroundColor: Color = .clear,
		foregroundColor: Color = .black,
		borderColor: Color? = nil,
		borderWidth: CGFloat = 0,
		cornerRadius: CGFloat = 0,
		font: Font = .system(size: 16),
		shadowColor: Color? = nil,
		shadowRadius: CGFloat = 0,
		shadowOpacity: Double = 0,
		padding: EdgeInsets = .init(),
		spacing: CGFloat = 0,
		icon: Image? = nil,
		disabledColor: Color? = nil,
		hoverEffect: HoverEffect = .automatic,
		accessibilityLabel: String? = nil
	) {
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
		self.borderColor = borderColor
		self.borderWidth = borderWidth
		self.cornerRadius = cornerRadius
		self.font = font
		self.shadowColor = shadowColor
		self.shadowRadius = shadowRadius
		self.shadowOpacity = shadowOpacity
		self.padding = padding
		self.spacing = spacing
		self.icon = icon
		self.disabledColor = disabledColor
		self.hoverEffect = hoverEffect
		self.accessibilityLabel = accessibilityLabel
	}
}
