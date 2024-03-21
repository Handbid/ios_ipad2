// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BorderButtonStyle: BaseButtonStyle {
	static let accent = EdgesButtonStyle(backgroundColor: .white, borderColor: .accent)

	var backgroundColor: UIColor
	var borderColor: UIColor
	var textColor: Color?

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding(padding)
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color(backgroundColor))
					.stroke(Color(borderColor), lineWidth: 2.0)
			)
			.foregroundStyle(textColor ?? Color(borderColor))
			.fontWeight(fontWieght)
	}
}
