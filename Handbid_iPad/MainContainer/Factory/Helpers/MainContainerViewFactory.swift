// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MainContainerViewFactory: MainContainerProtocolFactory {
	func makeAuctionView() -> AnyView {
		let service = DataServiceFactory.getService()
		let viewModel = AuctionViewModel(dataService: service)
		return AnyView(AuctionView(viewModel: viewModel))
	}

	func makePaddleView() -> AnyView {
		let service = DataServiceFactory.getService()
		let viewModel = PaddleViewModel(dataService: service)
		return AnyView(PaddleView(viewModel: viewModel))
	}
}
