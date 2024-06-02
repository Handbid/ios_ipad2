// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension GenericTopBarContent: TopBarContentProtocol {}

protocol TopBarContentFactory {
	associatedtype ViewModelType: ViewModelTopBarProtocol
	var viewModel: ViewModelType { get }
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> any TopBarContentProtocol
}

extension TopBarContentFactory {
	func createTopBarContent(isSidebarVisible: Binding<Bool>) -> any TopBarContentProtocol {
		GenericTopBarContent(isSidebarVisible: isSidebarVisible, viewModel: viewModel)
	}
}
