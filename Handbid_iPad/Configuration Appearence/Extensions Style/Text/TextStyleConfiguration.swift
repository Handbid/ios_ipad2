// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct TextStyleConfiguration {
	var fontStyle: Font
	var fontWeightStyle: Font.Weight
	var textAlignment: TextAlignment
	var alignment: Alignment
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
	var fixedSizeHorizontal: Bool
	var fixedSizeVertical: Bool
	var maxWidth: CGFloat?

	init(
		fontStyle: Font = .system(size: 16),
		fontWeightStyle: Font.Weight = .regular,
		textAlignment: TextAlignment = .leading,
		alignment: Alignment = .leading,
		isSecure: Bool = false,
		maxCharacterCount: Int = Int.max,
		defaultTextColor: Color = .bodyText,
		placeholderColor: Color = .gray,
		disabledColor: Color = .gray,
		backgroundColor: Color = .clear,
		errorColor: Color = .red,
		borderColor: Color = .clear,
		focusedBorderColorEnable: Bool = false,
		focusedBorderColor: Color = .clear,
		errorTextFont: Font = .system(size: 12),
		placeholderTextFont: Font = .system(size: 16),
		borderWidthValue: CGFloat = 1.0,
		roundedCornerRadius: CGFloat = 5.0,
		borderStyle: BorderType = .solid,
		autoCorrectionDisabled: Bool = false,
		fixedSizeHorizontal: Bool = false,
		fixedSizeVertical: Bool = true,
		maxWidth: CGFloat? = .infinity
	) {
		self.fontStyle = fontStyle
		self.fontWeightStyle = fontWeightStyle
		self.textAlignment = textAlignment
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
		self.fixedSizeHorizontal = fixedSizeHorizontal
		self.fixedSizeVertical = fixedSizeVertical
		self.maxWidth = maxWidth
	}

	enum BorderType {
		case solid
		case dashed
	}
}
