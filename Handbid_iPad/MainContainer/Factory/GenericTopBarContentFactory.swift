// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct GenericTopBarContentFactory<ViewModel: ViewModelTopBarProtocol> {
	var viewModel: ViewModel
	var deviceContext: DeviceContext

	init(viewModel: ViewModel, deviceContext: DeviceContext) {
		self.viewModel = viewModel
		self.deviceContext = deviceContext
	}

	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> some View {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel, logoIsVisible: false)
	}

	func createTopBarContentWithoutLogo() -> some View {
		GenericTopBarContent(isSidebarVisible: .constant(true), viewModel: viewModel, logoIsVisible: false)
	}
}
