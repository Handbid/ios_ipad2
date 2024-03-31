// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum TextLabelStyles {
	case headerTitle

	var configuration: TextFieldStyleConfiguration {
		switch self {
		case .headerTitle:
			TextFieldStyleConfiguration(
				fontStyle: .callout,
				fontWeightStyle: .medium
			)
		}
	}

	static func style(for type: TextLabelStyles) -> TextFieldStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		}
	}
}
