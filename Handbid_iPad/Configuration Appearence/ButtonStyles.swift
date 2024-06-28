// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum ButtonStyles {
	case primaryButtonStyle, secondaryButtonStyle, thirdButtonStyle, fourthButtonStyle, fifthButtonStyle

	var configuration: ButtonStyleConfiguration {
		switch self {
		case .primaryButtonStyle:
			ButtonStyleConfiguration(
				backgroundColor: .accentColor,
				foregroundColor: .white,
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold)
			)
		case .secondaryButtonStyle:
			ButtonStyleConfiguration(
				backgroundColor: .black,
				foregroundColor: .white,
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold),
				disabledColor: .white.opacity(0.5)
			)
		case .thirdButtonStyle:
			ButtonStyleConfiguration(
				foregroundColor: .accent,
				borderColor: .accent,
				borderWidth: 1,
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold)
			)
		case .fourthButtonStyle:
			ButtonStyleConfiguration(
				foregroundColor: .accent,
				font: .system(size: 13, weight: .semibold)
			)
		case .fifthButtonStyle:
			ButtonStyleConfiguration(
				foregroundColor: .bodyText,
				borderColor: .bodyText,
				borderWidth: 1,
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold)
			)
		}
	}

	var disabledConfiguration: ButtonStyleConfiguration {
		var config = configuration
		config.backgroundColor = config.disabledColor ?? .clear
		return config
	}
}
