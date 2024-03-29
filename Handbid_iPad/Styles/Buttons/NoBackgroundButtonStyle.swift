// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NoBackgroundButtonStyle: ButtonStyle {
	static let accent = NoBackgroundButtonStyle(textColor: .accent)

	var textColor: Color

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.modifier(BaseButtonSizeModifier())
			.background(.clear)
			.buttonLabelStyle(color: Color(textColor), uppercase: false)
	}
}
