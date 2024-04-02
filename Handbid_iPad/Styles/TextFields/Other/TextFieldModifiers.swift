// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BaseTextFieldStyle: TextFieldStyle {
	var cornerRadius: CGFloat
	var backgroundColor: Color
	var borderColor: Color
	var textColor: Color

	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.fullWidthStyle()
			.padding()
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(Color(backgroundColor))
					.stroke(Color(borderColor), lineWidth: 1.0)
			)
			.bodyTextStyle()
	}
}
