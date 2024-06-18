// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MyBidsView: ContentView {
	@ObservedObject var viewModel: MyBidsViewModel

	init(viewModel: MyBidsViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
				.accessibility(label: Text("My Bids Title"))
				.accessibility(identifier: "myBidsTitle")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentGrayBackground)
		.edgesIgnoringSafeArea(.all)
		.accessibilityIdentifier("MyBidsView")
	}
}
