// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BorderButtonStyle: ButtonStyle {
	static let accent = BorderButtonStyle(backgroundColor: .white, borderColor: .accent)

	var backgroundColor: UIColor
	var borderColor: UIColor
	var textColor: Color?

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.modifier(BaseButtonSizeModifier())
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color(backgroundColor))
					.stroke(Color(borderColor), lineWidth: 2.0)
			)
			.buttonLabelStyle(color: textColor ?? Color(borderColor))
	}
}
