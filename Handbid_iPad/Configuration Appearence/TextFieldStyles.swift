// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextFieldStyles {
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

	static func style(for type: TextFieldStyles) -> TextFieldStyleConfiguration {
		switch type {
		case .headerTitle: TextFieldStyles.headerTitle.configuration
		}
	}
}
