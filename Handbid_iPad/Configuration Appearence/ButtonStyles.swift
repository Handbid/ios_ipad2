// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum ButtonStyles {
	case primaryButtonStyle

	var configuration: ButtonStyleConfiguration {
		switch self {
		case .primaryButtonStyle:
			ButtonStyleConfiguration(
				backgroundColor: .purple,
				foregroundColor: .white,
				borderWidth: 0,
				cornerRadius: 10,
				font: .system(size: 16, weight: .semibold)
			)
		}
	}
}
