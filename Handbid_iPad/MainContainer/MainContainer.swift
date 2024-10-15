// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct MainContainer<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@EnvironmentObject private var authManager: AuthManager
	@StateObject var deviceContext = DeviceContext()
	@State var isSidebarVisible: Bool = DeviceConfigurator.isSidebarAlwaysVisible
	@State var selectedView: MainContainerTypeView
	@State var displayedOverlay: MainContainerOverlayTypeView
	@State var cancellables = Set<AnyCancellable>()

	private let auctionViewModel: AuctionViewModel
	private let paddleViewModel: PaddleViewModel
	private let myBidsViewModel: MyBidsViewModel
	private let managerViewModel: ManagerViewModel
	private let logOutViewModel: LogOutViewModel

	init(selectedView: MainContainerTypeView) {
		self.selectedView = selectedView
		self.displayedOverlay = .none
		(self.auctionViewModel, self.paddleViewModel, self.myBidsViewModel, self.managerViewModel, self.logOutViewModel) = ViewModelFactory.createAllViewModelsForMainContainer()
	}

	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				topBarContent(for: selectedView)
					.accessibility(identifier: "topBar")
				contentView()
					.accessibility(identifier: "contentView")
			}

			if displayedOverlay != .none {
				overlay()
			}
		}
		.onAppear {
			DispatchQueue.global().async {
				let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self,
				                                                  from: .auction)
				WebSocketManager.shared.startSocket(urlFactory: HandbidWebSocketFactory(),
				                                    token: authManager.currentToken,
				                                    auctionGuid: auction?.auctionGuid)
			}
			subscribeToViewModelEvents()
		}
		.navigationBarBackButtonHidden()
	}

	@ViewBuilder
	private func contentView() -> some View {
		HStack(spacing: 0) {
			if isSidebarVisible {
				sidebar()
					.accessibility(identifier: "sidebar")
			}
			mainContainer()
				.accessibility(identifier: "mainContainer")
		}
	}

	private func mainContainer() -> some View {
		MainContainerViewBuilder(selectedView: selectedView,
		                         auctionViewModel: auctionViewModel,
		                         paddleViewModel: paddleViewModel,
		                         myBidsViewModel: myBidsViewModel,
		                         managerViewModel: managerViewModel,
		                         logOutViewModel: logOutViewModel)
			.clipShape(RoundedCornerView(radius: 40, corners: .topLeft))
			.edgesIgnoringSafeArea(.bottom)
	}

	private func sidebar() -> some View {
		Sidebar(selectedView: $selectedView)
			.frame(width: 90)
			.transition(.move(edge: .leading).combined(with: .opacity))
			.animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
			.zIndex(1)
	}

	private func overlay() -> some View {
		MainContainerOverlayBuilder(selectedOverlay: displayedOverlay,
		                            auctionViewModel: auctionViewModel)
			.frame(width: .infinity, height: .infinity)
			.edgesIgnoringSafeArea(.all)
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
		case .searchItems:
			// selectedView = .logout
			coordinator.push(MainContainerPage.searchItems as! T)
		case .allAuctions:
			coordinator.popToRoot()
		case .filterItems:
			displayedOverlay = .filterItems
		case .closeOverlay:
			displayedOverlay = .none
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
