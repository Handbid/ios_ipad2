// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ManagerViewModel: ObservableObject, ViewModelTopBarProtocol {
	var eventPublisher = PassthroughSubject<MainContainerChangeViewEvents, Never>()
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
			TopBarAction(icon: "allAuctionsIcon", title: LocalizedStringKey("topBar_btn_allAuction"), action: allAuctions),
		]
	}

	func allAuctions() {
		eventPublisher.send(MainContainerChangeViewEvents.allAuctions)
	}
}
