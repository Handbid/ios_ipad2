// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct GenericTopBarContentFactory<ViewModel: ViewModelTopBarProtocol>: TopBarContentFactory {
	var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}
