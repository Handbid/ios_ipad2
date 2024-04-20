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
					ZStack(alignment: .leading) {
						MainContainerViewBuilder(selectedView: selectedView)
							.frame(width: geometry.size.width)
							.clipShape(TopLeftRoundedCorner(radius: 40, corners: .topLeft))
							.zIndex(0)
							.edgesIgnoringSafeArea(.bottom)

						if isSidebarVisible {
							Sidebar(selectedView: $selectedView)
								.frame(width: 90)
								.transition(.move(edge: .leading).combined(with: .opacity))
								.animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
								.zIndex(1)
						}
					}
				}
				else {
					HStack(spacing: 0) {
						if isSidebarVisible {
							Sidebar(selectedView: $selectedView)
								.frame(width: 90)
								.transition(.move(edge: .leading))
								.animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
						}
						MainContainerViewBuilder(selectedView: selectedView)
							.frame(width: isSidebarVisible ? geometry.size.width - 90 : geometry.size.width)
							.clipShape(TopLeftRoundedCorner(radius: 40, corners: .topLeft))
							.edgesIgnoringSafeArea(.bottom)
					}
				}
			}
		}
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
