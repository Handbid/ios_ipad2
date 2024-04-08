// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextFieldStyles {
	case form

	var configuration: TextStyleConfiguration {
		switch self {
		case .form:
			TextStyleConfiguration(
				fontStyle: .body,
				fontWeightStyle: .medium,
				textAlignment: .leading,
				alignment: .leading,
				defaultTextColor: .black,
				placeholderColor: .accentGrayForm,
				borderColor: .accentGrayForm,
				borderWidthValue: 1
			)
		}
	}

	static func style(for type: TextFieldStyles) -> TextStyleConfiguration {
		switch type {
		case .form: TextFieldStyles.form.configuration
		}
	}
}
