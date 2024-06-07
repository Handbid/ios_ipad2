// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol MainContainerProtocolFactory {
	associatedtype AuctionViewType: View
	associatedtype PaddleViewType: View
	associatedtype MyBidsViewType: View
	associatedtype ManagerViewType: View
	associatedtype LogOutViewType: View

	func makeAuctionView() -> AuctionViewType
	func makePaddleView() -> PaddleViewType
	func makeMyBidsView() -> MyBidsViewType
	func makeManagerView() -> ManagerViewType
	func makeLogOutView() -> LogOutViewType
}
