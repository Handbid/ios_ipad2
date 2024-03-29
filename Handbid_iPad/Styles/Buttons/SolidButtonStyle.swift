// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SolidButtonStyle: ButtonStyle {
	static let accent = SolidButtonStyle(backgroundColor: UIColor.accent)
	static let primary = SolidButtonStyle(backgroundColor: UIColor(named: "PrimaryButtonColor") ?? .black)

	var backgroundColor: UIColor

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.modifier(BaseButtonSizeModifier())
			.background(Color(backgroundColor))
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
			.buttonLabelStyle(color: .white)
	}
}
