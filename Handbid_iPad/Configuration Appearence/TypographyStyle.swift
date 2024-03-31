// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TypographyStyle {
	case headerTitleRegistration

	private var fontName: String {
		switch self {
		case .headerTitleRegistration:
			"Inter.ttf"
		}
	}

	private var fontTextStyle: Font.TextStyle {
		switch self {
		case .headerTitleRegistration:
			.title
		}
	}

	private var fontSize: CGFloat {
		switch self {
		case .headerTitleRegistration:
			40
		}
	}

	func asFont() -> Font {
		Font.custom(fontName, size: fontSize, relativeTo: fontTextStyle)
	}
}
