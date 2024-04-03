// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextSecuredStyles {
	case formField

	var configuration: TextStyleConfiguration {
		switch self {
		case .formField:
			TextStyleConfiguration(
                fontStyle: .body,
                fontWeightStyle: .medium,
                defaultTextColor: .black,
                placeholderColor: .accentGrayForm,
                borderColor: .accentGrayForm,
                borderWidthValue: 1
			)
		}
	}

	static func style(for type: TextSecuredStyles) -> TextStyleConfiguration {
		switch type {
		case .formField: TextSecuredStyles.formField.configuration
		}
	}
}
