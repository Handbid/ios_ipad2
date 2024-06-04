// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI

class MockMainContainerProtocolFactory: MainContainerProtocolFactory {
	func makeAuctionView() -> AnyView {
		AnyView(Text("Mock Auction View"))
	}

	func makePaddleView() -> AnyView {
		AnyView(Text("Mock Paddle View"))
	}

	func makeMyBidsView() -> AnyView {
		AnyView(Text("Mock My Bids View"))
	}

	func makeManagerView() -> AnyView {
		AnyView(Text("Mock Manager View"))
	}

	func makeLogOutView() -> AnyView {
		AnyView(Text("Mock Log Out View"))
	}
}
