// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class PaddleTopBarContentFactory<ViewModel: ViewModelTopBarProtocol>: TopBarContentFactory {
	private(set) var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		PaddleTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}
