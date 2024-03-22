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

extension View {
    private func baseTextStyle(
        color: Color,
        size: CGFloat,
        weight: Font.Weight = Font.Weight.bold) -> some View {
            modifier(BaseLabelModifier(
                textColor: color,
                font: Font.custom("Inter", size: size),
                fontWeight: weight
            )
            )
        }

	func buttonLabelStyle(color: Color) -> some View {
		baseTextStyle(color: color, size: 16.0)
	}

	func titleTextStyle() -> some View {
		baseTextStyle(color: .headerText, size: 40.0)
	}

	func subTitleTextStyle() -> some View {
		baseTextStyle(color: .headerText, size: 32.0)
	}

	func bodyTextStyle() -> some View {
        baseTextStyle(color: .bodyText, size: 16.0, weight: Font.Weight.regular)
	}
}
