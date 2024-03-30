// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FullWidthModifier: ViewModifier {
	func body(content: Content) -> some View {
		content.frame(maxWidth: .infinity)
	}
}
