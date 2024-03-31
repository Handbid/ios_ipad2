// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum SecuredTextStyles {
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

	static func style(for type: SecuredTextStyles) -> TextFieldStyleConfiguration {
		switch type {
		case .headerTitle: SecuredTextStyles.headerTitle.configuration
		}
	}
}
