// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

protocol TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent
}

struct AuctionTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		AuctionTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct PaddleTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		PaddleTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct MyBidsTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		MyBidsTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct ManagerTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		ManagerTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct DefaultTopBarContentFactory: TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		DefaultTopBarContent(isSidebarVisible: isSidebarVisible)
	}
}

struct EmptyAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var authManager = AuthManager()
	@State private var selectedView: String = "Auction"
	@State private var isSidebarVisible: Bool = true

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView))
			HStack(spacing: 0) {
				if isSidebarVisible {
					Sidebar(selectedView: $selectedView)
				}
				MainView(selectedView: selectedView)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}

	func topBarContent(for view: String) -> TopBarContent {
		let factory: TopBarContentFactory = switch view {
		case "Auction":
			AuctionTopBarContentFactory()
		case "Paddle":
			PaddleTopBarContentFactory()
		case "My Bids":
			MyBidsTopBarContentFactory()
		case "Manager":
			ManagerTopBarContentFactory()
		default:
			DefaultTopBarContentFactory()
		}
		return factory.createTopBarContent(isSidebarVisible: $isSidebarVisible)
	}
}

protocol TopBarContent {
	var leftView: AnyView { get }
	var centerView: AnyView { get }
	var rightView: AnyView { get }
}

struct AuctionTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftView: AnyView {
		AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")

		})
	}

	var centerView: AnyView {
		AnyView(VStack {
			Text("Auction Name")
			Text("Date of Auction").font(.subheadline)
		})
	}

	var rightView: AnyView {
		AnyView(HStack {
			Button(action: {}) { Image(systemName: "magnifyingglass") }
			Button(action: {}) { Image(systemName: "line.horizontal.3.decrease.circle") }
			Button(action: {}) { Image(systemName: "arrow.clockwise") }
		})
	}
}

struct PaddleTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftView: AnyView {
		AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})
	}

	var centerView: AnyView {
		AnyView(Text("Paddle Number"))
	}

	var rightView: AnyView {
		AnyView(EmptyView())
	}
}

struct MyBidsTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftView: AnyView {
		AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})
	}

	var centerView: AnyView {
		AnyView(Text("My Bids"))
	}

	var rightView: AnyView {
		AnyView(EmptyView())
	}
}

struct ManagerTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftView: AnyView {
		AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})
	}

	var centerView: AnyView {
		AnyView(Text("Auction Name"))
	}

	var rightView: AnyView {
		AnyView(Button(action: {}) { Image(systemName: "square.stack.3d.down.right") })
	}
}

struct DefaultTopBarContent: TopBarContent {
	@Binding var isSidebarVisible: Bool

	var leftView: AnyView {
		AnyView(Button(action: {
			isSidebarVisible.toggle()
		}) {
			Image(systemName: "line.horizontal.3")
		})
	}

	var centerView: AnyView {
		AnyView(Text("Select a View"))
	}

	var rightView: AnyView {
		AnyView(EmptyView())
	}
}

struct TopBar: View {
	var content: TopBarContent
	static let barHeight: CGFloat = 60

	var body: some View {
		HStack {
			content.leftView.padding(.leading, 10) // Dodaj padding po lewej stronie
			Spacer()
			content.centerView
			Spacer()
			content.rightView.padding(.trailing, 10) // Dodaj padding po prawej stronie
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
		.padding(10) // Zastosuj padding do całego VStack
		.frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
		.background(Color.blue)
		.foregroundColor(.white)
	}
}

struct MainView: View {
	var selectedView: String

	var body: some View {
		VStack {
			Text("\(selectedView) Content Goes Here")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray.opacity(0.1))
	}
}
