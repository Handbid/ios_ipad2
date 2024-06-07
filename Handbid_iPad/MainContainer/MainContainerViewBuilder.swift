// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MainContainerViewBuilder: View {
	@EnvironmentObject var viewFactory: AnyViewMainContainerFactory
	var selectedView: MainContainerTypeView

	@ViewBuilder
	var body: some View {
		switch selectedView {
		case .auction:
			viewFactory.makeAuctionView()
		case .paddle:
			viewFactory.makePaddleView()
		case .myBids:
			viewFactory.makeMyBidsView()
		case .manager:
			viewFactory.makeManagerView()
		case .logout:
			viewFactory.makeLogOutView()
		case .searchItems:
			viewFactory.makeSearchItemsView()
		}
	}
}
