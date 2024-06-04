// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TypographyStyle {
	case headerTitleRegistration

	var fontName: String {
		switch self {
		case .headerTitleRegistration:
			"Inter"
		}
	}

	var fontTextStyle: Font.TextStyle {
		switch self {
		case .headerTitleRegistration:
			.headline
		}
	}

	var iPhoneFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			26
		}
	}

	var iPadFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		}
	}

	var fontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		}
	}

	func asFont() -> Font {
		let fontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? iPadFontSize : iPhoneFontSize
		return Font.custom(fontName, size: fontSize, relativeTo: fontTextStyle)
	}
}
