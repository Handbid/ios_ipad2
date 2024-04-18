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

	init() {
		let dataService = DataServiceFactory.getService()
		self.auctionViewModel = AuctionViewModel(dataService: dataService)
		self.paddleViewModel = PaddleViewModel(dataService: dataService)
	}

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView))
			GeometryReader { geometry in
				HStack(spacing: 0) {
					if isSidebarVisible {
						Sidebar(selectedView: $selectedView)
							.frame(width: 80)
							.transition(.move(edge: .leading))
					}
					MainContainerViewBuilder(selectedView: selectedView)
						.frame(width: isSidebarVisible ? geometry.size.width - 80 : geometry.size.width)
				}
			}
		}
	}

	private func topBarContent(for viewType: MainContainerTypeView) -> TopBarContent {
		switch viewType {
		case .auction:
			AuctionTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .paddle:
			PaddleTopBarContentFactory(viewModel: paddleViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		}
	}
}
