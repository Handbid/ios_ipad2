// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct GenericTopBarContentFactory<ViewModel: ViewModelTopBarProtocol>: TopBarContentFactory {
	var viewModel: ViewModel
	@ObservedObject var deviceContext: DeviceContext

	init(viewModel: ViewModel, deviceContext: DeviceContext) {
		self.viewModel = viewModel
		self.deviceContext = deviceContext
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		if deviceContext.isPhone {
			GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
		}
		else {
			GenericTopBarContent(isSidebarVisible: .constant(true), viewModel: viewModel, logo: Image("menuLogoIcon"))
		}
	}
}
