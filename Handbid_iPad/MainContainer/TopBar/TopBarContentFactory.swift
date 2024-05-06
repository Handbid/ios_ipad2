// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol TopBarContentFactory {
	associatedtype ViewModelType: ViewModelTopBarProtocol
	var viewModel: ViewModelType { get }
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent
}

extension TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> TopBarContent {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel) as! TopBarContent
	}
}
