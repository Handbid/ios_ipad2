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
		MainContainerViewBuilder(selectedView: selectedView,
		                         auctionViewModel: auctionViewModel,
		                         paddleViewModel: paddleViewModel,
		                         myBidsViewModel: myBidsViewModel,
		                         managerViewModel: managerViewModel,
		                         logOutViewModel: logOutViewModel)
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
