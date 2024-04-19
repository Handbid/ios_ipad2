// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct MainContainer<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()

	@State private var selectedView: MainContainerTypeView = .auction
	@State private var isSidebarVisible: Bool = true

	let auctionViewModel: AuctionViewModel
	var paddleViewModel: PaddleViewModel
	let myBidsViewModel: MyBidsViewModel
	let managerViewModel: ManagerViewModel
	let logOutViewModel: LogOutViewModel

	init() {
		let dataService = DataServiceFactory.getService()
		self.auctionViewModel = AuctionViewModel(dataService: dataService)
		self.paddleViewModel = PaddleViewModel(dataService: dataService)
		self.myBidsViewModel = MyBidsViewModel(dataService: dataService)
		self.managerViewModel = ManagerViewModel(dataService: dataService)
		self.logOutViewModel = LogOutViewModel(dataService: dataService)
	}

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView))
			GeometryReader { geometry in
				HStack(spacing: 0) {
					if isSidebarVisible {
						Sidebar(selectedView: $selectedView)
							.frame(width: 90)
							.transition(.move(edge: .leading))
					}
					MainContainerViewBuilder(selectedView: selectedView)
						.frame(width: isSidebarVisible ? geometry.size.width - 90 : geometry.size.width)
				}
			}
		}
	}

	private func topBarContent(for viewType: MainContainerTypeView) -> TopBarContent {
		switch viewType {
		case .auction:
			GenericTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .paddle:
			GenericTopBarContentFactory(viewModel: paddleViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .myBids:
			GenericTopBarContentFactory(viewModel: myBidsViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .manager:
			GenericTopBarContentFactory(viewModel: managerViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .logout:
			GenericTopBarContentFactory(viewModel: logOutViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		}
	}
}
