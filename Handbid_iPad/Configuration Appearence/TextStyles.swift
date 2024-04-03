// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextLabelStyles {
	case headerTitle, body, error

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.headerTitleRegistration.asFont(),
				fontWeightStyle: .semibold,
                alignment: .center
			)
		case .body:
			TextStyleConfiguration(
				fontStyle: .body, fontWeightStyle: .medium,
				alignment: .center
			)
		case .error:
			TextStyleConfiguration(
				fontStyle: .caption, fontWeightStyle: .medium,
				alignment: .center,
				defaultTextColor: Color(hex: "#E2296C")
			)
		}
	}

	static func style(for type: TextLabelStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		case .body: TextLabelStyles.body.configuration
		case .error: TextLabelStyles.error.configuration
		}
	}
}
