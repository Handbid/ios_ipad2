// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogOutView: ContentView {
	@ObservedObject var viewModel: LogOutViewModel

	init(viewModel: LogOutViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentGrayBackground)
		.edgesIgnoringSafeArea(.all)
	}
}
