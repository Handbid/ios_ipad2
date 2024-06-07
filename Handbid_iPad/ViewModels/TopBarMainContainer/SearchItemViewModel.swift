// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Paddle Number"
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
