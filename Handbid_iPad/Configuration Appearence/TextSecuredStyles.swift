// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextSecuredStyles {
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

	static func style(for type: TextSecuredStyles) -> TextFieldStyleConfiguration {
		switch type {
		case .headerTitle: TextSecuredStyles.headerTitle.configuration
		}
	}
}
