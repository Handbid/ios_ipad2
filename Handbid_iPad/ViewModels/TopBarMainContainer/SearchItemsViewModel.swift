// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemsViewModel: ObservableObject, ViewModelTopBarProtocol {
	var actions: [TopBarAction] { [] }
	private let dataManager: DataManager?

	init(dataManager: DataManager? = nil) {
		self.dataManager = dataManager
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(type: .custom, customView: AnyView(EmptyView()))
	}
}
