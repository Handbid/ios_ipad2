// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MyBidsSubViewFactory: View {
	@ObservedObject var viewModel: MyBidsViewModel
	let inspection = Inspection<Self>()

	var body: some View {
		let view: any View = switch viewModel.subView {
		case .findPaddle:
			FindBidderView(viewModel: viewModel)
		case .detailsPurchaseBidder:
			BidderDetailsView(viewModel: viewModel)
		}

		AnyView(view)
			.onReceive(inspection.notice) {
				inspection.visit(self, $0)
			}
	}
}
