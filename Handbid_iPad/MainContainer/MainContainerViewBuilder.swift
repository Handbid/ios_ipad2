// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MainContainerViewBuilder: View {
	var selectedView: MainContainerTypeView
	var auctionViewModel: AuctionViewModel
	var paddleViewModel: PaddleViewModel
	var myBidsViewModel: MyBidsViewModel
	var managerViewModel: ManagerViewModel
	var logOutViewModel: LogOutViewModel

	@ViewBuilder
	var body: some View {
		switch selectedView {
		case .auction:
			AuctionView(viewModel: auctionViewModel)
		case .paddle:
			PaddleView(viewModel: paddleViewModel)
		case .myBids:
			MyBidsView(viewModel: myBidsViewModel)
		case .manager:
			ManagerView(viewModel: managerViewModel)
		case .logout:
			LogOutView(viewModel: logOutViewModel)
		}
	}
}
