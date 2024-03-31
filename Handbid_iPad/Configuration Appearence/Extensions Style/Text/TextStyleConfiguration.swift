// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct TextStyleConfiguration {
	var fontStyle: Font
	var fontWeightStyle: Font.Weight
	var alignment: TextAlignment
	var isSecure: Bool
	var maxCharacterCount: Int
	var defaultTextColor: Color
	var placeholderColor: Color
	var disabledColor: Color
	var backgroundColor: Color
	var errorColor: Color
	var borderColor: Color
	var focusedBorderColorEnable: Bool
	var focusedBorderColor: Color
	var errorTextFont: Font
	var placeholderTextFont: Font
	var borderWidthValue: CGFloat
	var roundedCornerRadius: CGFloat
	var borderStyle: BorderType
	var autoCorrectionDisabled: Bool

	init(
		fontStyle: Font = .system(size: 16),
		fontWeightStyle: Font.Weight = .regular,
		alignment: TextAlignment = .leading,
		isSecure: Bool = false,
		maxCharacterCount: Int = Int.max,
		defaultTextColor: Color = .black,
		placeholderColor: Color = .gray,
		disabledColor: Color = .gray,
		backgroundColor: Color = .white,
		errorColor: Color = .red,
		borderColor: Color = .gray,
		focusedBorderColorEnable: Bool = false,
		focusedBorderColor: Color = .blue,
		errorTextFont: Font = .system(size: 12),
		placeholderTextFont: Font = .system(size: 16),
		borderWidthValue: CGFloat = 1.0,
		roundedCornerRadius: CGFloat = 5.0,
		borderStyle: BorderType = .solid,
		autoCorrectionDisabled: Bool = false
	) {
		self.fontStyle = fontStyle
		self.fontWeightStyle = fontWeightStyle
		self.alignment = alignment
		self.isSecure = isSecure
		self.maxCharacterCount = maxCharacterCount
		self.defaultTextColor = defaultTextColor
		self.placeholderColor = placeholderColor
		self.disabledColor = disabledColor
		self.backgroundColor = backgroundColor
		self.errorColor = errorColor
		self.borderColor = borderColor
		self.focusedBorderColorEnable = focusedBorderColorEnable
		self.focusedBorderColor = focusedBorderColor
		self.errorTextFont = errorTextFont
		self.placeholderTextFont = placeholderTextFont
		self.borderWidthValue = borderWidthValue
		self.roundedCornerRadius = roundedCornerRadius
		self.borderStyle = borderStyle
		self.autoCorrectionDisabled = autoCorrectionDisabled
	}

	enum BorderType {
		case solid
		case dashed
	}
}
