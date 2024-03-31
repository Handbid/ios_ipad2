// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextStyles {
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
}
