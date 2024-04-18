// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AnyViewMainContainerFactory: ObservableObject {
	private let _makeAuctionView: () -> AnyView
	private let _makePaddleView: () -> AnyView

	init<VF: MainContainerProtocolFactory>(wrappedFactory: VF) where VF.AuctionViewType == AnyView, VF.PaddleViewType == AnyView {
		self._makeAuctionView = { AnyView(wrappedFactory.makeAuctionView()) }
		self._makePaddleView = { AnyView(wrappedFactory.makePaddleView()) }
	}

	func makeAuctionView() -> AnyView {
		_makeAuctionView()
	}

	func makePaddleView() -> AnyView {
		_makePaddleView()
	}
}
