// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AnyViewMainContainerFactory: ObservableObject {
	private let auctionView: () -> AnyView
	private let paddleView: () -> AnyView
	private let myBidsView: () -> AnyView
	private let managerView: () -> AnyView
	private let logOutView: () -> AnyView
	private let searchItemsView: () -> AnyView

	init<VF: MainContainerProtocolFactory>(wrappedFactory: VF) where VF.AuctionViewType == AnyView, VF.PaddleViewType == AnyView {
		self.auctionView = { AnyView(wrappedFactory.makeAuctionView()) }
		self.paddleView = { AnyView(wrappedFactory.makePaddleView()) }
		self.myBidsView = { AnyView(wrappedFactory.makeMyBidsView()) }
		self.managerView = { AnyView(wrappedFactory.makeManagerView()) }
		self.logOutView = { AnyView(wrappedFactory.makeLogOutView()) }
		self.searchItemsView = { AnyView(wrappedFactory.makeSearchItemsView()) }
	}

	func makeAuctionView() -> AnyView {
		auctionView()
	}

	func makePaddleView() -> AnyView {
		paddleView()
	}

	func makeMyBidsView() -> AnyView {
		myBidsView()
	}

	func makeManagerView() -> AnyView {
		managerView()
	}

	func makeLogOutView() -> AnyView {
		logOutView()
	}

	func makeSearchItemsView() -> AnyView {
		searchItemsView()
	}
}
