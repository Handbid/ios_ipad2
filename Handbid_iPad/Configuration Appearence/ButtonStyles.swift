// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum ButtonStyles {
	case primaryButtonStyle, secondaryButtonStyle, thirdButtonStyle, fourthButtonStyle, fifthButtonStyle

	var configuration: ButtonStyleConfiguration {
		switch self {
		case .primaryButtonStyle:
			ButtonStyleConfiguration(
				backgroundColor: Color(hex: "#694BFF"),
				foregroundColor: Color(hex: "#FFFFFF"),
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold)
			)
		case .secondaryButtonStyle:
			ButtonStyleConfiguration(
				backgroundColor: Color(hex: "#000000"),
				foregroundColor: Color(hex: "#FFFFFF"),
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold),
				disabledColor: Color(hex: "#000000").opacity(0.5)
			)
		case .thirdButtonStyle:
			ButtonStyleConfiguration(
				foregroundColor: Color(hex: "#694BFF"),
				borderColor: Color(hex: "#694BFF"),
				borderWidth: 1,
				cornerRadius: 40,
				font: .system(size: 16, weight: .semibold)
			)
		case .fourthButtonStyle:
			ButtonStyleConfiguration(
				foregroundColor: Color(hex: "#694BFF"),
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
