// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionView: ContentView {
	@ObservedObject var viewModel: AuctionViewModel

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
				.accessibility(label: Text("Auction Title"))
				.accessibility(identifier: "auctionTitle")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentGrayBackground)
		.edgesIgnoringSafeArea(.all)
	}
}
