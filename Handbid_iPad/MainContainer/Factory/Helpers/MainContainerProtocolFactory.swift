// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol MainContainerProtocolFactory {
	associatedtype AuctionViewType: View
	associatedtype PaddleViewType: View

	func makeAuctionView() -> AuctionViewType
	func makePaddleView() -> PaddleViewType
}
