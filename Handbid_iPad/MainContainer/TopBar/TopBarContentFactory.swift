// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension GenericTopBarContent: TopBarContent {}

protocol TopBarContentFactory {
	associatedtype ViewModelType: ViewModelTopBarProtocol
	var viewModel: ViewModelType { get }
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> any TopBarContent
}

extension TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> any TopBarContent {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}
