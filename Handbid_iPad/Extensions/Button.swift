// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension View {
	/// Apply button style with solid background and AccentColor
	func solidAccentButtonStyle() -> some View {
		buttonStyle(SolidButtonStyle.accent)
	}

	/// Apply button style with solid backgroun and PrimaryButtonColor
	func solidPrimaryButtonStyle() -> some View {
		buttonStyle(SolidButtonStyle.primary)
	}

	/// Apply button style with bordered background and AccentColor
	func borderAccentButtonStyle() -> some View {
		buttonStyle(BorderButtonStyle.accent)
	}

	/// Apply button style without background and text in AccentColor
	func noBackgroundAccentButtonStyle() -> some View {
		buttonStyle(NoBackgroundButtonStyle.accent)
	}
}
