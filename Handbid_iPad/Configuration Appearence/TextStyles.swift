// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextLabelStyles {
    case headerTitle, body, formHeader, error

    var configuration: TextStyleConfiguration {
        switch self {
        case .headerTitle:
            return TextStyleConfiguration(
                fontStyle: TypographyStyle.headerTitleRegistration.asFont(),
                fontWeightStyle: .semibold,
                alignment: .center
            )
        case .body:
            return TextStyleConfiguration(
                fontStyle: .body,
                fontWeightStyle: .medium,
                alignment: .center
            )
        case .error:
            return TextStyleConfiguration(
                fontStyle: .caption,
                fontWeightStyle: .medium,
                alignment: .center,
                defaultTextColor: Color(hex: "#E2296C")
            )
        case .formHeader:
            return TextStyleConfiguration(
                fontStyle: .callout,
                fontWeightStyle: .light,
                alignment: .leading,
                defaultTextColor: .accentGrayForm
            )
        }
    }

	static func style(for type: TextLabelStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		case .body: TextLabelStyles.body.configuration
		case .error: TextLabelStyles.error.configuration
        case .formHeader: TextLabelStyles.formHeader.configuration
        }
	}
}
