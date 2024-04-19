// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GenericTopBarContent<ViewModel: ViewModelTopBarProtocol>: TopBarContent {
	@Binding var isSidebarVisible: Bool
	var viewModel: ViewModel
	var logo: Image?

	var leftViews: [AnyView] {
		if let logo {
			[AnyView(logo.foregroundColor(.primary))]
		}
		else {
			[createMenuButton()]
		}
	}

	var centerView: AnyView {
		createCenterView()
	}

	var rightViews: [AnyView] {
		viewModel.actions.map { action in
			createActionButton(for: action)
		}
	}

	private func createMenuButton() -> AnyView {
		Button(action: { isSidebarVisible.toggle() }) {
			Image("menuIcon").foregroundColor(.primary)
		}.eraseToAnyView()
	}

	private func createCenterView() -> AnyView {
		switch viewModel.centerViewData.type {
		case .title:
			Text(viewModel.centerViewData.title ?? "")
				.bold()
				.eraseToAnyView()
		case .image:
			viewModel.centerViewData.image
				.foregroundColor(.primary)
				.eraseToAnyView()
		case .custom:
			viewModel.centerViewData.customView ?? EmptyView().eraseToAnyView()
		}
	}

	private func createActionButton(for action: TopBarAction) -> AnyView {
		Button(action: action.action) {
			Image(action.icon).scaledToFit().frame(width: 30).foregroundColor(.primary)
		}.eraseToAnyView()
	}
}
