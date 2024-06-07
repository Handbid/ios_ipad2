// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SearchItemView<T: PageProtocol>: View {
	@ObservedObject var viewModel: SearchItemViewModel

	var body: some View {
		ZStack {
			Text("hej")
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}
}
