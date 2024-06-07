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

	func makeMyBidsView() -> AnyView {
		let service = DataServiceFactory.getService()
		let viewModel = MyBidsViewModel(dataService: service)
		return AnyView(MyBidsView(viewModel: viewModel))
	}

	func makeManagerView() -> AnyView {
		let service = DataServiceFactory.getService()
		let viewModel = ManagerViewModel(dataService: service)
		return AnyView(ManagerView(viewModel: viewModel))
	}

	func makeLogOutView() -> AnyView {
		let service = DataServiceFactory.getService()
		let viewModel = LogOutViewModel(dataService: service)
		return AnyView(LogOutView(viewModel: viewModel))
	}
}
