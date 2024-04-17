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

class MyBidsTopBarContentFactory: TopBarContentFactory {
	private var viewModel: MyBidsViewModel

	init(viewModel: MyBidsViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		MyBidsTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

class ManagerTopBarContentFactory: TopBarContentFactory {
	private var viewModel: ManagerViewModel

	init(viewModel: ManagerViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		ManagerTopBarContent(isSidebarVisible: isSidebarVisible, onAllAuctions: viewModel.allAuction)
	}
}

class DefaultTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		DefaultTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct EmptyAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()
	@State private var selectedView: String = "Auction"
	@State private var isSidebarVisible: Bool = true

	@StateObject private var auctionViewModel = AuctionViewModel()
	@StateObject private var paddleViewModel = PaddleViewModel()
	@StateObject private var myBidsViewModel = MyBidsViewModel()
	@StateObject private var managerViewModel = ManagerViewModel()

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
			AuctionTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case "Paddle":
			PaddleTopBarContentFactory(viewModel: paddleViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case "My Bids":
			MyBidsTopBarContentFactory(viewModel: myBidsViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case "Manager":
			ManagerTopBarContentFactory(viewModel: managerViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		default:
			DefaultTopBarContentFactory().createTopBarContent(isSidebarVisible: $isSidebarVisible)
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

struct MyBidsTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftViews: [AnyView] {
		[AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})]
	}

	var centerView: AnyView {
		AnyView(Text("My Bids"))
	}

	var rightViews: [AnyView] {
		[]
	}
}

struct ManagerTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var onAllAuctions: () -> Void

	var leftViews: [AnyView] {
		[AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})]
	}

	var centerView: AnyView {
		AnyView(Text("Auction Name"))
	}

	var rightViews: [AnyView] {
		[AnyView(HStack {
			Button(action: onAllAuctions) { Image(systemName: "square.stack.3d.down.right") }
		})]
	}
}

struct DefaultTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftViews: [AnyView] {
		[AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})]
	}

	var centerView: AnyView {
		AnyView(Text("Select a View"))
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
			Button("My Bids") {
				selectedView = "My Bids"
			}
			Button("Manager") {
				selectedView = "Manager"
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
		case "My Bids":
			MyBidsView(viewModel: MyBidsViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		case "Manager":
			ManagerView(viewModel: ManagerViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		default:
			Text("Select a View")
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

class MyBidsViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "My Bids"
	@Published var numberOfBids = "You have 5 active bids"
}

class ManagerViewModel: ObservableObject, ViewModelProtocol {
	@Published var title = "Auction Manager"
	@Published var status = "Next auction setup in progress"

	func allAuction() {}
}

protocol ContentViewProtocol: View {}

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

struct MyBidsView: ContentViewProtocol {
	@ObservedObject var viewModel: MyBidsViewModel

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.yellow)
		.edgesIgnoringSafeArea(.all)
	}
}

struct ManagerView: ContentViewProtocol {
	@ObservedObject var viewModel: ManagerViewModel

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.green)
		.edgesIgnoringSafeArea(.all)
	}
}
