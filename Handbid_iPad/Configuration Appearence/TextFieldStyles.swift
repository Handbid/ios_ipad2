// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextFieldStyles {
	case form, searchBar

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
		case .searchBar:
			TextStyleConfiguration(
				fontStyle: .body,
				fontWeightStyle: .medium,
				textAlignment: .leading,
				alignment: .leading,
				defaultTextColor: .black,
				placeholderColor: .accentGrayBorder,
				borderColor: .accentGrayBorder,
				borderWidthValue: 1,
				roundedCornerRadius: 30
			)
		}
	}

	static func style(for type: TextFieldStyles) -> TextStyleConfiguration {
		switch type {
		case .form: TextFieldStyles.form.configuration
		case .searchBar: TextFieldStyles.searchBar.configuration
		}
	}
}
