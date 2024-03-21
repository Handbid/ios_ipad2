// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SolidButtonStyle: BaseButtonStyle {
	static let accent = SolidButtonStyle(backgroundColor: UIColor.accent)
	static let primary = SolidButtonStyle(backgroundColor: UIColor(named: "PrimaryButtonColor") ?? .black)

	var backgroundColor: UIColor

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding(padding)
			.background(Color(backgroundColor))
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
			.foregroundStyle(textColor)
			.fontWeight(fontWieght)
	}
}
