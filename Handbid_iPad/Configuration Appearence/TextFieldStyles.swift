// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextFieldStyles {
	case headerTitle

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				fontStyle: .callout,
				fontWeightStyle: .medium
			)
		}
	}

	static func style(for type: TextFieldStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextFieldStyles.headerTitle.configuration
		}
	}
}
