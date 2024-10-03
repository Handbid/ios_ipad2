// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MainContainerOverlayBuilder: View {
	var selectedOverlay: MainContainerOverlayTypeView
	var auctionViewModel: AuctionViewModel
	var invoiceViewModel: InvoiceViewModel?
	var dismissOverlay: () -> Void

	var body: some View {
		switch selectedOverlay {
		case .filterItems:
			FiltersItemsView(viewModel: auctionViewModel)
		case .invoiceView:
			if let invoiceViewModel {
				InvoiceView(
					viewModel: invoiceViewModel,
					dismissAction: dismissOverlay
				)
			}
			else {
				EmptyView()
			}
		default:
			EmptyView()
		}
	}
}
