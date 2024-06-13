// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TypographyStyle {
	case headerTitleRegistration, subheader, small

	var fontName: String {
		switch self {
		case .headerTitleRegistration, .subheader, .small:
			"Inter"
		}
	}

	var fontTextStyle: Font.TextStyle {
		switch self {
		case .headerTitleRegistration, .subheader:
			.headline
		case .small:
			.body
		}
	}

	var iPhoneFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			26
		case .subheader:
			24
		case .small:
			16
		}
	}

	var iPadFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		case .subheader:
			24
		case .small:
			16
		}
	}

	var fontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		case .subheader:
			24
		case .small:
			16
		}
	}

	func asFont() -> Font {
		let fontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? iPadFontSize : iPhoneFontSize
		return Font.custom(fontName, size: fontSize, relativeTo: fontTextStyle)
	}
}
