// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension ButtonStyle {
	var cornerRadius: CGFloat {
		40.0
	}
}

struct BaseButtonSizeModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding()
			.fullWidthStyle()
	}
}
