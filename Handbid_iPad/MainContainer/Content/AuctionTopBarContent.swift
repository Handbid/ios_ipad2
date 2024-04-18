// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionTopBarContent<ViewModel: ViewModelTopBarProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel

	var leftViews: [AnyView] {
		[AnyView(Button(action: { isSidebarVisible.toggle() }) { Image(systemName: "line.horizontal.3") })]
	}

	var centerView: AnyView {
		switch viewModel.centerViewData.type {
		case .title:
			AnyView(Text(viewModel.centerViewData.title ?? "").bold())
		case .image:
			AnyView(viewModel.centerViewData.image ?? Image(systemName: "photo"))
		case .custom:
			viewModel.centerViewData.customView ?? AnyView(EmptyView())
		}
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			AnyView(Button(action: action.action) { Image(systemName: action.icon) })
		}
	}
}
