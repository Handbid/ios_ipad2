// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GenericTopBarContent<ViewModel: ViewModelTopBarProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) { Image(systemName: "line.horizontal.3") })]
	}

	var centerView: AnyView {
		viewModel.centerViewContent
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			AnyView(Button(action: action.action) { Image(systemName: action.icon) })
		}
	}
}
