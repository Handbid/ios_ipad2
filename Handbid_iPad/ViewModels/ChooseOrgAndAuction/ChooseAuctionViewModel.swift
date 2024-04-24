// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ChooseAuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var cancellables = Set<AnyCancellable>()

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .custom,
			customView: AnyView(SelectAuctionTopBarCenterView(title: "org name",
			                                                  countAuctions: 10))
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "closeIcon", title: nil, action: closeView),
		]
	}

	func closeView() {
		print("close")
	}
}
