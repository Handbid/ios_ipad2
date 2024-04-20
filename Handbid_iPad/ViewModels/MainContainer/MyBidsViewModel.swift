// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class MyBidsViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "My Bids"
	var actions: [TopBarAction] { [] }

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}
}
