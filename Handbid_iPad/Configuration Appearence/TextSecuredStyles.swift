// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextSecuredStyles {
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

	static func style(for type: TextSecuredStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextSecuredStyles.headerTitle.configuration
		}
	}
}
