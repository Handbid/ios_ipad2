// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class PaddleViewModel: ObservableObject, ViewModelTopBarProtocol {
	@Published var title = "Paddle Information"
	@Published var paddleNumber = "Paddle #102"
	@ObservedObject var dataService: DataServiceWrapper

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
			// TopBarAction(icon: "plus", action: addPaddle),
		]
	}

	private func addPaddle() {
		print("Add paddle")
	}
}