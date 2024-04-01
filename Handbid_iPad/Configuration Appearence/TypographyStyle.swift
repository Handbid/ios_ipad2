// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TypographyStyle {
	case headerTitleRegistration

	private var fontName: String {
		switch self {
		case .headerTitleRegistration:
			"Inter"
		}
	}

	private var fontTextStyle: Font.TextStyle {
		switch self {
		case .headerTitleRegistration:
			.headline
		}
	}

	private var iPhoneFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			26
		}
	}

	private var iPadFontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		}
	}

	private var fontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		}
	}

	func asFont() -> Font {
		let fontSize: CGFloat = if UIDevice.current.userInterfaceIdiom == .pad {
			iPadFontSize
		}
		else {
			iPhoneFontSize
		}
		return Font.custom(fontName, size: fontSize, relativeTo: fontTextStyle)
	}
}
