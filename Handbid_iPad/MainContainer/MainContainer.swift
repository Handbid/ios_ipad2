// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct MainContainer<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@EnvironmentObject private var authManager: AuthManager
	@StateObject var deviceContext = DeviceContext()
	@State var isSidebarVisible: Bool = DeviceConfigurator.isSidebarAlwaysVisible
	@State var selectedView: MainContainerTypeView
	@State var cancellables = Set<AnyCancellable>()

	private let auctionViewModel: AuctionViewModel
	private let paddleViewModel: PaddleViewModel
	private let myBidsViewModel: MyBidsViewModel
	private let managerViewModel: ManagerViewModel
	private let logOutViewModel: LogOutViewModel

	init(selectedView: MainContainerTypeView) {
		self.selectedView = selectedView
		(self.auctionViewModel, self.paddleViewModel, self.myBidsViewModel, self.managerViewModel, self.logOutViewModel) = ViewModelFactory.createAllViewModelsForMainContainer()
	}

	var body: some View {
		VStack(spacing: 0) {
			topBarContent(for: selectedView)
				.accessibility(identifier: "topBar")
			GeometryReader { geometry in
				if deviceContext.isPhone {
					phoneView(geometry: geometry)
						.accessibility(identifier: "phoneView")
				}
				else {
					tabletView(geometry: geometry)
						.accessibility(identifier: "tabletView")
				}
			}
		}
		.onAppear {
			DispatchQueue.global().async {
				WebSocketManager.shared.startSocket(urlFactory: HandbidWebSocketFactory(),
				                                    token: authManager.currentToken)
			}
			subscribeToViewModelEvents()
		}
		.navigationBarBackButtonHidden()
	}

	@ViewBuilder
	private func phoneView(geometry: GeometryProxy) -> some View {
		ZStack(alignment: .leading) {
			mainContainer(geometry: geometry)
				.accessibility(identifier: "mainContainer")

			if isSidebarVisible {
				sidebar(geometry: geometry)
					.accessibility(identifier: "sidebar")
			}
		}
	}

	@ViewBuilder
	private func tabletView(geometry: GeometryProxy) -> some View {
		HStack(spacing: 0) {
			if isSidebarVisible {
				sidebar(geometry: geometry)
					.accessibility(identifier: "sidebar")
			}
			mainContainer(geometry: geometry)
				.accessibility(identifier: "mainContainer")
		}
	}

	private func mainContainer(geometry: GeometryProxy) -> some View {
		MainContainerViewBuilder(selectedView: selectedView)
			.frame(width: deviceContext.isPhone || !isSidebarVisible ? geometry.size.width : geometry.size.width - 90)
			.clipShape(RoundedCornerView(radius: 40, corners: .topLeft))
			.edgesIgnoringSafeArea(.bottom)
	}

	private func sidebar(geometry _: GeometryProxy) -> some View {
		Sidebar(selectedView: $selectedView)
			.frame(width: 90)
			.transition(.move(edge: .leading).combined(with: .opacity))
			.animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
			.zIndex(1)
	}

	private func subscribeToViewModelEvents() {
		auctionViewModel.eventPublisher
			.sink { event in
				handleViewModelEvent(event)
			}
			.store(in: &cancellables)

		managerViewModel.eventPublisher
			.sink { event in
				handleViewModelEvent(event)
			}
			.store(in: &cancellables)
	}

	private func handleViewModelEvent(_ event: MainContainerChangeViewEvents) {
		switch event {
		case .search:
			coordinator.push(MainContainerPage.searchItems as! T)
		case .allAuctions:
			coordinator.popToRoot()
		}
	}

	private func topBarContent(for viewType: MainContainerTypeView) -> some View {
		switch viewType {
		case .auction:
			AnyView(GenericTopBarContentFactory(viewModel: auctionViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible))
		case .paddle:
			AnyView(GenericTopBarContentFactory(viewModel: paddleViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible))
		case .myBids:
			AnyView(GenericTopBarContentFactory(viewModel: myBidsViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible))
		case .manager:
			AnyView(GenericTopBarContentFactory(viewModel: managerViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible))
		case .logout:
			AnyView(GenericTopBarContentFactory(viewModel: logOutViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible))
		}
	}
}
