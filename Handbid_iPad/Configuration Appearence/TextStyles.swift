// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum TextLabelStyles {
	case headerTitle, body

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.headerTitleRegistration.asFont(),
				fontWeightStyle: .semibold
			)
		case .body:
			TextStyleConfiguration(
				fontStyle: .body, fontWeightStyle: .medium,
				alignment: .center
			)
		}
	}

	static func style(for type: TextLabelStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		case .body: TextLabelStyles.body.configuration
		}
	}
}
