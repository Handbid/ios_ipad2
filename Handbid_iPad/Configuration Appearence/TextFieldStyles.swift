// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextStyles {
	case headerTitle
	case otherStyle

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				font: .title,
				fontWeight: .bold,
				foregroundColor: .blue,
				alignment: .center,
				rounded: true // Example value for rounded
			)
		case .otherStyle:
			TextStyleConfiguration(
				font: .headline,
				fontWeight: .regular,
				foregroundColor: .black,
				alignment: .leading,
				rounded: false
			)
		}
	}
}
