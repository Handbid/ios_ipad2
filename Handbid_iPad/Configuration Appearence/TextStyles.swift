// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum TextLabelStyles {
	case headerTitle, bottom

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.headerTitleRegistration.asFont(),
				fontWeightStyle: .semibold
			)
		case .bottom:
			TextStyleConfiguration(fontStyle: .largeTitle, fontWeightStyle: .bold)
		}
	}

	static func style(for type: TextLabelStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		case .bottom: TextLabelStyles.bottom.configuration
		}
	}
}
