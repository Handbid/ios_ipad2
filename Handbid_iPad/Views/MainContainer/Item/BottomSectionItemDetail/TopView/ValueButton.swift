// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ValueButton: View {
	let action: () -> Void
	let label: String

	var body: some View {
		Button(action: action) {
			Text(label)
				.font(.title)
				.fontWeight(.bold)
				.textCase(.uppercase)
				.background(Color.clear)
				.foregroundColor(.primary)
				.clipShape(Circle())
		}
		.accessibilityIdentifier(label)
	}
}
