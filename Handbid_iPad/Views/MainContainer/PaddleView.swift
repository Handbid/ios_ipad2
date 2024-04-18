// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleView: ContentView {
	@ObservedObject var viewModel: PaddleViewModel

	init(viewModel: PaddleViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray)
		.edgesIgnoringSafeArea(.all)
	}
}
