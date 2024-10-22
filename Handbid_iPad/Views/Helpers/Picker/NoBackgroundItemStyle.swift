// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NoBackgroundItemStyle<Data>: ViewModifier where Data: Hashable {
	let item: Data
	let selection: Data

	func body(content: Content) -> some View {
		VStack {
			content
				.foregroundStyle(item == selection ? .managerTabSelected : .managerTab)
				.fontWeight(item == selection ? .bold : .regular)
				.padding(.bottom, 4)

			Rectangle()
				.frame(maxWidth: .infinity, minHeight: 2, maxHeight: 5)
				.foregroundStyle(.managerTabSelected)
				.opacity(item == selection ? 1.0 : 0.0)
		}
		.frame(maxHeight: 34, alignment: .leading)
	}
}
