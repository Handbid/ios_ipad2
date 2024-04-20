// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct MainContainer<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()

	@State private var selectedView: MainContainerTypeView = .auction
	@State private var isSidebarVisible: Bool = DeviceConfigurator.isSidebarAlwaysVisible
	@StateObject private var deviceContext = DeviceContext()

	let auctionViewModel: AuctionViewModel
	var paddleViewModel: PaddleViewModel
	let myBidsViewModel: MyBidsViewModel
	let managerViewModel: ManagerViewModel
	let logOutViewModel: LogOutViewModel

	init() {
		(self.auctionViewModel, self.paddleViewModel, self.myBidsViewModel, self.managerViewModel, self.logOutViewModel) = ViewModelFactory.createAllViewModels()
	}

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView))
			GeometryReader { geometry in
				if deviceContext.isPhone {
					phoneView(geometry: geometry)
				}
				else {
					tabletView(geometry: geometry)
				}
			}
		}
	}

	@ViewBuilder
	private func phoneView(geometry: GeometryProxy) -> some View {
		ZStack(alignment: .leading) {
			mainContainer(geometry: geometry)

			if isSidebarVisible {
				sidebar(geometry: geometry)
			}
		}
	}

	@ViewBuilder
	private func tabletView(geometry: GeometryProxy) -> some View {
		HStack(spacing: 0) {
			if isSidebarVisible {
				sidebar(geometry: geometry)
			}
			mainContainer(geometry: geometry)
		}
	}

	private func mainContainer(geometry: GeometryProxy) -> some View {
		MainContainerViewBuilder(selectedView: selectedView)
			.frame(width: deviceContext.isPhone || !isSidebarVisible ? geometry.size.width : geometry.size.width - 90)
			.clipShape(TopLeftRoundedCorner(radius: 40, corners: .topLeft))
			.edgesIgnoringSafeArea(.bottom)
	}

	private func sidebar(geometry _: GeometryProxy) -> some View {
		Sidebar(selectedView: $selectedView)
			.frame(width: 90)
			.transition(.move(edge: .leading).combined(with: .opacity))
			.animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
			.zIndex(1)
	}

	private func topBarContent(for _: MainContainerTypeView) -> TopBarContent {
		GenericTopBarContentFactory(viewModel: auctionViewModel, deviceContext: deviceContext).createTopBarContent(isSidebarVisible: $isSidebarVisible)
	}
}

struct TopLeftRoundedCorner: Shape {
	var radius: CGFloat
	var corners: UIRectCorner

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
