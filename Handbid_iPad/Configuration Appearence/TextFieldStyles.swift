// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextStyles {
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

	static func style(for type: TextStyles) -> TextFieldStyleConfiguration {
		switch type {
		case .headerTitle: TextStyles.headerTitle.configuration
		}
	}
}
