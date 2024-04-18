// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

protocol TopBarContentFactory {
	associatedtype ViewModelType: ViewModelProtocol
	var viewModel: ViewModelType { get }
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent
}

extension TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}

protocol DataService {
	func fetchData()
	func refreshData()
}

class AuctionDataService: DataService {
	func fetchData() {}
	func refreshData() {}
}

struct AuctionTopBarContentFactory<ViewModel: ViewModelProtocol>: TopBarContentFactory {
	var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		AuctionTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}

class PaddleTopBarContentFactory<ViewModel: ViewModelProtocol>: TopBarContentFactory {
	private(set) var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		PaddleTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
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

	let auctionViewModel: AuctionViewModel = .init(dataService: AuctionDataService())
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
			AuctionTopBarContentFactory(viewModel: auctionViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		case .paddle:
			PaddleTopBarContentFactory(viewModel: paddleViewModel).createTopBarContent(isSidebarVisible: $isSidebarVisible)
		}
	}
}

class AnyViewModel: ViewModelProtocol {
	private let _centerViewContent: () -> AnyView
	private let _actions: () -> [TopBarAction]

	var centerViewContent: AnyView {
		_centerViewContent()
	}

	var actions: [TopBarAction] {
		_actions()
	}

	init(_ viewModel: some ViewModelProtocol) {
		self._centerViewContent = { viewModel.centerViewContent }
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

struct AuctionTopBarContent<ViewModel: ViewModelProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) { Image(systemName: "line.horizontal.3") })]
	}

	var centerView: AnyView {
		viewModel.centerViewContent
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			AnyView(Button(action: action.action) { Image(systemName: action.icon) })
		}
	}
}

struct PaddleTopBarContent<ViewModel: ViewModelProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) {
			Image(systemName: "line.horizontal.3")
		})]
	}

	var centerView: AnyView {
		viewModel.centerViewContent
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
		.padding([.vertical, .leading, .trailing], 10)
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
	let auctionDataService: DataService = AuctionDataService()

	@ViewBuilder
	var body: some View {
		switch selectedView {
		case .auction:
			AuctionView(viewModel: AuctionViewModel(dataService: auctionDataService))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		case .paddle:
			PaddleView(viewModel: PaddleViewModel())
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

protocol ViewModelProtocol: ObservableObject, TopBarActionProvider {
	var centerViewContent: AnyView { get }
}

class AuctionViewModel: ObservableObject, ViewModelProtocol {
	var dataService: DataService

	@Published var title = "Auction Details"
	@Published var auctionDate = "Next Auction: Tomorrow"

	init(dataService: DataService) {
		self.dataService = dataService
	}

	var centerViewContent: AnyView {
		AnyView(VStack {
			Text(title).bold()
			Text("Date: \(auctionDate)").font(.subheadline)
		})
	}

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

	var centerViewContent: AnyView {
		AnyView(VStack {
			Text(title).bold()
		})
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "plus", action: { print("Add paddle") }),
		]
	}
}

protocol ContentViewProtocol {
	associatedtype ViewModel: ViewModelProtocol
	static func create(viewModel: ViewModel) -> Self
}

class GenericTopBarContentFactory<ViewModelType: ViewModelProtocol>: TopBarContentFactory {
	var viewModel: ViewModelType

	init(viewModel: ViewModelType) {
		self.viewModel = viewModel
	}
}

struct GenericTopBarContent<ViewModel: ViewModelProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) { Image(systemName: "line.horizontal.3") })]
	}

	var centerView: AnyView {
		viewModel.centerViewContent
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			AnyView(Button(action: action.action) { Image(systemName: action.icon) })
		}
	}
}

struct AuctionView: View, ContentViewProtocol {
	@ObservedObject var viewModel: AuctionViewModel

	static func create(viewModel: AuctionViewModel) -> AuctionView {
		AuctionView(viewModel: viewModel)
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.red)
		.edgesIgnoringSafeArea(.all)
	}
}

struct PaddleView: View {
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

extension PaddleView: ContentViewProtocol {
	static func create(viewModel: PaddleViewModel) -> PaddleView {
		PaddleView(viewModel: viewModel)
	}
}
