// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AnyViewMainContainerFactory: ObservableObject {
	private let auctionView: () -> AnyView
	private let paddleView: () -> AnyView

	init<VF: MainContainerProtocolFactory>(wrappedFactory: VF) where VF.AuctionViewType == AnyView, VF.PaddleViewType == AnyView {
		self.auctionView = { AnyView(wrappedFactory.makeAuctionView()) }
		self.paddleView = { AnyView(wrappedFactory.makePaddleView()) }
	}

	func makeAuctionView() -> AnyView {
		auctionView()
	}

	func makePaddleView() -> AnyView {
		paddleView()
	}
}
