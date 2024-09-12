// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum TextLabelStyles {
	case headerTitle, body, formHeader, error, searchBar,
	     subheader, accentBody, leadingLabel, titleLeading, itemDetailValue, itemDetailDescription

	var configuration: TextStyleConfiguration {
		switch self {
		case .headerTitle:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.headerTitleRegistration.asFont(),
				fontWeightStyle: .semibold,
				textAlignment: .center,
				alignment: .center
			)
		case .body:
			TextStyleConfiguration(
				fontStyle: .body,
				fontWeightStyle: .medium,
				textAlignment: .center,
				alignment: .center
			)
		case .error:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.small.asFont(),
				fontWeightStyle: .medium,
				textAlignment: .center,
				alignment: .center,
				defaultTextColor: .statusError
			)
		case .formHeader:
			TextStyleConfiguration(
				fontStyle: .callout,
				fontWeightStyle: .light,
				textAlignment: .leading,
				alignment: .leading,
				defaultTextColor: .accentGrayForm
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
		case .subheader:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.subheader.asFont(),
				fontWeightStyle: .bold,
				textAlignment: .leading,
				alignment: .leading,
				defaultTextColor: .bodyText
			)
		case .accentBody:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.small.asFont(),
				textAlignment: .leading,
				alignment: .leading,
				defaultTextColor: .accent,
				maxWidth: nil
			)
		case .leadingLabel:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.small.asFont(),
				textAlignment: .leading,
				alignment: .leading,
				maxWidth: nil
			)
		case .titleLeading:
			TextStyleConfiguration(
				fontStyle: TypographyStyle.subheader.asFont(),
				textAlignment: .leading,
				alignment: .leading
			)
		case .itemDetailValue:
			TextStyleConfiguration(
				fontStyle: .headline,
				fontWeightStyle: .bold,
				textAlignment: .leading,
				alignment: .leading
			)
		case .itemDetailDescription:
			TextStyleConfiguration(
				fontStyle: .title2,
				fontWeightStyle: .medium,
				textAlignment: .center,
				alignment: .center
			)
		}
	}

	static func style(for type: TextLabelStyles) -> TextStyleConfiguration {
		switch type {
		case .headerTitle: TextLabelStyles.headerTitle.configuration
		case .body: TextLabelStyles.body.configuration
		case .error: TextLabelStyles.error.configuration
		case .formHeader: TextLabelStyles.formHeader.configuration
		case .searchBar: TextLabelStyles.searchBar.configuration
		case .subheader: TextLabelStyles.subheader.configuration
		case .accentBody: TextLabelStyles.accentBody.configuration
		case .leadingLabel: TextLabelStyles.leadingLabel.configuration
		case .titleLeading: TextLabelStyles.titleLeading.configuration
		case .itemDetailValue: TextLabelStyles.itemDetailValue.configuration
		case .itemDetailDescription: TextLabelStyles.itemDetailDescription.configuration
		}
	}
}
