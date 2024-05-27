// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GenericTopBarContent<ViewModel: ViewModelTopBarProtocol>: View {
	@Binding var isSidebarVisible: Bool
	var logoIsVisible: Bool? = true
	@ObservedObject var viewModel: ViewModel
	var logo: Image?

	var body: some View { // This is necessary for conforming to View
		HStack {
			ForEach(leftViews.indices, id: \.self) { index in
				leftViews[index]
			}

			Spacer()

			centerView

			Spacer()

			HStack {
				ForEach(rightViews.indices, id: \.self) { index in
					rightViews[index]
				}
			}
		}
		.padding()
		.frame(height: 60) // or any appropriate height
		.background(Color(.systemBackground)) // appropriate background color
		.foregroundColor(.primary)
	}

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
			if logoIsVisible == true {
				Image("menuIcon").foregroundColor(.primary)
			}
		}.eraseToAnyView()
	}

	private func createCenterView() -> AnyView {
		switch viewModel.centerViewData.type {
		case .title:
			Text(viewModel.centerViewData.title ?? "")
				.bold()
				.lineLimit(1)
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
			if let title = action.title {
				Text(title)
					.lineLimit(1)
					.font(.caption)
					.bold()
			}
		}.eraseToAnyView()
	}
}
