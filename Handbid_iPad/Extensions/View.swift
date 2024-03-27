// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension View {
	/// Apply BaseTextFieldStyle to TextField or view's subviews that are TextFields
	func basicTextFieldStyle() -> some View {
		textFieldStyle(
			BaseTextFieldStyle(cornerRadius: 8, backgroundColor: .white, borderColor: .hbGray, textColor: .bodyText)
		)
	}

	/// Apply BaseLabelModifier with params to View
	private func baseTextStyle(
		color: Color,
		size: CGFloat,
		weight: Font.Weight = Font.Weight.semibold
	) -> some View {
		modifier(BaseLabelModifier(
			textColor: color,
			font: Font.custom("Inter", size: size),
			fontWeight: weight
		)
		)
	}

	/// Style designed for use in Button labels
	func buttonLabelStyle(color: Color) -> some View {
		baseTextStyle(color: color, size: 16.0)
	}

	/// Style designed for title sections in screens, similar to system .title style
	func titleTextStyle() -> some View {
		baseTextStyle(color: .headerText, size: 40.0)
	}

	/// Style designed for second level title sections, similar to system .title2
	func subTitleTextStyle() -> some View {
		baseTextStyle(color: .headerText, size: 32.0)
	}

	/// Style designed for body text sections of screens, like descriptions etc
	func bodyTextStyle() -> some View {
		baseTextStyle(color: .bodyText, size: 16.0, weight: Font.Weight.regular)
	}

	/// Easily apply modifier that makes view take up as much space horizontally as possible
	func fullWidthStyle() -> some View {
		modifier(FullWidthModifier())
	}
}
