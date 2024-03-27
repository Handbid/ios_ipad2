// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension Button {
	/// Apply button style with solid background and AccentColor
	func solidAccentStyle() -> some View {
		buttonStyle(SolidButtonStyle.accent)
	}

	/// Apply button style with solid backgroun and PrimaryButtonColor
	func solidPrimaryStyle() -> some View {
		buttonStyle(SolidButtonStyle.primary)
	}

	/// Apply button style with bordered background and AccentColor
	func borderAccentStyle() -> some View {
		buttonStyle(BorderButtonStyle.accent)
	}
}
