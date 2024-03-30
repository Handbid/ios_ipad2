// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum ButtonStyles {
	case primaryButtonStyle

	var configuration: ButtonStyleSettings {
		switch self {
		case .primaryButtonStyle:
			ButtonStyleSettings(
				backgroundColor: .purple,
				foregroundColor: .white,
				borderWidth: 0,
				cornerRadius: 10,
				font: .system(size: 16, weight: .semibold)
			)
		}
	}
}
