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

enum MainContainerViewType {
	case auction
	case paddle
}

struct EmptyAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()

	@State private var selectedView: MainContainerViewType = .auction
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
							.frame(width: 80)
							.transition(.move(edge: .leading))
					}
					MainView(selectedView: selectedView)
						.frame(width: isSidebarVisible ? geometry.size.width - 80 : geometry.size.width)
				}
			}
		}
	}

	private func topBarContent(for viewType: MainContainerViewType) -> TopBarContent {
		switch viewType {
		case .auction:
			GenericTopBarContentFactory(viewModel: AnyViewModel(auctionViewModel)).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .paddle:
			GenericTopBarContentFactory(viewModel: AnyViewModel(paddleViewModel)).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		}
	}
}

class AnyViewModel: ViewModelProtocol {
	private let _title: () -> String
	private let _actions: () -> [TopBarAction]

	var title: String { _title() }
	var actions: [TopBarAction] { _actions() }

	init(_ viewModel: some ViewModelProtocol) {
		self._title = { viewModel.title }
		self._actions = { viewModel.actions }
	}
}

protocol TopBarContent {
	var leftViews: [AnyView] { get }
	var centerView: AnyView { get }
	var rightViews: [AnyView] { get }
}

protocol TopBarActionProvider {
	var actions: [TopBarAction] { get }
}

struct TopBarAction {
	let icon: String
	let action: () -> Void
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
	@Binding var selectedView: MainContainerViewType

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Button("Auction") {
				selectedView = .auction
			}
			Button("Paddle") {
				selectedView = .paddle
			}
		}
		.padding(10)
		.frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
		.background(Color.blue)
		.foregroundColor(.white)
	}
}

struct MainView: View {
	var selectedView: MainContainerViewType

	@ViewBuilder
	var body: some View {
		switch selectedView {
		case .auction:
			AuctionView(viewModel: AuctionViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		case .paddle:
			PaddleView(viewModel: PaddleViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

protocol ViewModelProtocol: ObservableObject, TopBarActionProvider {
	var title: String { get }
}

class AuctionViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Auction Details"
	@Published var auctionDate = "Next Auction: Tomorrow"

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "magnifyingglass", action: searchData),
			TopBarAction(icon: "line.horizontal.3.decrease.circle", action: filterData),
			TopBarAction(icon: "arrow.clockwise", action: refreshData),
		]
	}

	func searchData() {}
	func filterData() {}
	func refreshData() {}
}

class PaddleViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Paddle Information"
	@Published var paddleNumber = "Paddle #102"

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "plus", action: { print("Add paddle") }),
		]
	}
}

// class ManagerViewModel: ObservableObject, ViewModelProtocol {
//	@Published var title = "Auction Manager"
//	@Published var status = "Next auction setup in progress"
//
//	var actions: [TopBarAction] {
//		[
//			TopBarAction(icon: "plus", action: allAuction),
//		]
//	}
//
//	func allAuction() {}
// }

protocol ContentViewProtocol: View {
	associatedtype ViewModel: ViewModelProtocol
	init(viewModel: ViewModel)
}

class GenericTopBarContentFactory: TopBarContentFactory {
	private var viewModel: AnyViewModel

	init(viewModel: AnyViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}

struct GenericTopBarContent<ViewModel: ViewModelProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) { Image(systemName: "line.horizontal.3") })]
	}

	var centerView: AnyView {
		AnyView(Text(viewModel.title))
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			AnyView(Button(action: action.action) { Image(systemName: action.icon) })
		}
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
