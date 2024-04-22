// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class LogOutViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Logout Details"
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
