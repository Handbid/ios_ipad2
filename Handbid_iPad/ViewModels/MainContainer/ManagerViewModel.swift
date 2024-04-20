// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class ManagerViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper

	@Published var title = "Manager Details"

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "allAuctionsIcon", title: "All auctions", action: searchData),
		]
	}

	func searchData() {}
	func refreshData() {}
	func filterData() {}
}
