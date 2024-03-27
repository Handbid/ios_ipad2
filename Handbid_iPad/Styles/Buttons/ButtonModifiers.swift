// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BaseButtonSizeModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding()
			.fullWidthStyle()
	}
}
