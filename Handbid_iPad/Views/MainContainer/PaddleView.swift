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
				.accessibility(label: Text("Paddle Title"))
				.accessibility(identifier: "paddleTitle")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentGrayBackground)
		.edgesIgnoringSafeArea(.all)
		.accessibilityIdentifier("PaddleView")
	}
}
