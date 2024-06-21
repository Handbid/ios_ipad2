// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MainContainerOverlayBuilder: View {
	var selectedOverlay: MainContainerOverlayTypeView
	var auctionViewModel: AuctionViewModel

	var body: some View {
		switch selectedOverlay {
		case .filterItems:
			FiltersItemsView(viewModel: auctionViewModel)
		default:
			EmptyView()
		}
	}
}
