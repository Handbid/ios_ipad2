// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

protocol TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent
}

class AuctionTopBarContentFactory: TopBarContentFactory {
	private var viewModel: AuctionViewModel

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		AuctionTopBarContent(isSidebarVisible: isSidebarVisible, onSearch: viewModel.searchData, onFilter: viewModel.filterData, onRefresh: viewModel.refreshData)
	}
}

class PaddleTopBarContentFactory: TopBarContentFactory {
	private var viewModel: PaddleViewModel

	init(viewModel: PaddleViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		PaddleTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct EmptyAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()

	@State private var selectedView: String = "Auction"
	@State private var isSidebarVisible: Bool = true

	var auctionViewModel: AuctionViewModel = .init()
	var paddleViewModel: PaddleViewModel = .init()

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView))
			GeometryReader { geometry in
				HStack(spacing: 0) {
					if isSidebarVisible {
						Sidebar(selectedView: $selectedView)
							.frame(width: 150)
							.transition(.move(edge: .leading))
					}
					MainView(selectedView: selectedView)
						.frame(width: isSidebarVisible ? geometry.size.width - 150 : geometry.size.width)
				}
			}
		}
	}

	func topBarContent(for view: String) -> TopBarContent {
		switch view {
		case "Auction":
			GenericTopBarContentFactory(viewModel: auctionViewModel) { isSidebarVisible, viewModel in
				AuctionTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
			}.createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case "Paddle":
			GenericTopBarContentFactory(viewModel: paddleViewModel) { isSidebarVisible, _ in
				PaddleTopBarContent(isSidebarVisible: isSidebarVisible)
			}.createTopBarContent(isSidebarVisible: $isSidebarVisible)
		default:
			GenericTopBarContentFactory(viewModel: auctionViewModel) { isSidebarVisible, viewModel in
				AuctionTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
			}.createTopBarContent(isSidebarVisible: $isSidebarVisible)
		}
	}
}

protocol TopBarContent {
	var leftViews: [AnyView] { get }
	var centerView: AnyView { get }
	var rightViews: [AnyView] { get }
}

struct AuctionTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var onSearch: () -> Void
	var onFilter: () -> Void
	var onRefresh: () -> Void

	var leftViews: [AnyView] {
		[
			AnyView(Button(action: { isSidebarVisible.toggle() }) {
				Image(systemName: "line.horizontal.3")
			}),
		]
	}

	var centerView: AnyView {
		AnyView(Text("Auction Details"))
	}

	var rightViews: [AnyView] {
		[
			AnyView(HStack {
				Button(action: onSearch) { Image(systemName: "magnifyingglass") }
				Button(action: onFilter) { Image(systemName: "line.horizontal.3.decrease.circle") }
				Button(action: onRefresh) { Image(systemName: "arrow.clockwise") }
			}),
		]
	}
}

struct PaddleTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftViews: [AnyView] {
		[AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})]
	}

	var centerView: AnyView {
		AnyView(Text("Paddle Number"))
	}

	var rightViews: [AnyView] {
		[]
	}
}

struct TopBar: View {
	var content: TopBarContent
	static let barHeight: CGFloat = 60

	var body: some View {
		HStack {
			ForEach(Array(content.leftViews.enumerated()), id: \.offset) { _, view in view }
			Spacer()
			content.centerView
			Spacer()
			ForEach(Array(content.rightViews.enumerated()), id: \.offset) { _, view in view }
		}
		.padding(.vertical, 10)
		.frame(height: TopBar.barHeight)
		.background(Color.blue)
		.foregroundColor(.white)
	}
}

struct Sidebar: View {
	@Binding var selectedView: String

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Button("Auction") {
				selectedView = "Auction"
			}
			Button("Paddle") {
				selectedView = "Paddle"
			}
		}
		.padding(10)
		.frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
		.background(Color.blue)
		.foregroundColor(.white)
	}
}

struct MainView: View {
	var selectedView: String

	@ViewBuilder
	var body: some View {
		switch selectedView {
		case "Auction":
			AuctionView(viewModel: AuctionViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		case "Paddle":
			PaddleView(viewModel: PaddleViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		default:
			AuctionView(viewModel: AuctionViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

protocol ViewModelProtocol: ObservableObject {
	var title: String { get }
}

class AuctionViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Auction Details"
	@Published var auctionDate = "Next Auction: Tomorrow"

	func searchData() {}
	func filterData() {}
	func refreshData() {}
}

class PaddleViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Paddle Information"
	@Published var paddleNumber = "Paddle #102"
}

class ManagerViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Auction Manager"
	@Published var status = "Next auction setup in progress"

	func allAuction() {}
}

protocol ContentViewProtocol: View {
	associatedtype ViewModel: ViewModelProtocol
	init(viewModel: ViewModel)
}

class GenericTopBarContentFactory<ViewModel: ViewModelProtocol>: TopBarContentFactory {
	private var viewModel: ViewModel
	private var contentProvider: (Binding<Bool>, ViewModel) -> TopBarContent

	init(viewModel: ViewModel, contentProvider: @escaping (Binding<Bool>, ViewModel) -> TopBarContent) {
		self.viewModel = viewModel
		self.contentProvider = contentProvider
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		contentProvider(isSidebarVisible, viewModel)
	}
}

struct AuctionView: ContentViewProtocol {
	@ObservedObject var viewModel: AuctionViewModel

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.red)
		.edgesIgnoringSafeArea(.all)
	}
}

struct PaddleView: ContentViewProtocol {
	@ObservedObject var viewModel: PaddleViewModel

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray)
		.edgesIgnoringSafeArea(.all)
	}
}
