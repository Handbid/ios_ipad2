// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class MyBidsViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper

	@Published var title = "My Bids"

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	var actions: [TopBarAction] { [] }

	func searchData() {}
	func refreshData() {}
	func filterData() {}
}
