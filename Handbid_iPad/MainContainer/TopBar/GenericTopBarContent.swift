// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GenericTopBarContent<ViewModel: ViewModelTopBarProtocol>: View {
	@Binding var isSidebarVisible: Bool
	@ObservedObject var viewModel: ViewModel
	var inspection = Inspection<Self>()
	var logoIsVisible: Bool? = true
	var logo: Image?

	var body: some View {
		HStack {
			ForEach(leftViews.indices, id: \.self) { index in
				leftViews[index]
			}

			Spacer()

			centerView
				.accessibilityElement(children: .combine)
				.accessibilityLabel("Center View")

			Spacer()

			HStack {
				ForEach(rightViews.indices, id: \.self) { index in
					rightViews[index]
				}
			}
		}
		.padding()
		.frame(height: 60)
		.background(Color(.systemBackground))
		.foregroundColor(.primary)
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
	}

	var leftViews: [AnyView] {
		if let logo {
			[AnyView(logo.foregroundColor(.primary)
					.accessibilityLabel("Logo"))]
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
				Image("menuIcon")
					.foregroundColor(.primary)
					.accessibilityLabel("Menu Button")
			}
		}
		.accessibility(label: Text("Menu Button"))
		.eraseToAnyView()
	}

	private func createCenterView() -> AnyView {
		switch viewModel.centerViewData.type {
		case .title:
			Text(viewModel.centerViewData.title ?? "")
				.bold()
				.lineLimit(1)
				.accessibilityLabel(viewModel.centerViewData.title ?? "Title")
				.eraseToAnyView()
		case .image:
			viewModel.centerViewData.image?
				.foregroundColor(.primary)
				.accessibilityLabel("Center Image")
				.eraseToAnyView() ?? EmptyView().eraseToAnyView()
		case .custom:
			viewModel.centerViewData.customView?
				.accessibilityLabel("Custom Center View")
				.eraseToAnyView() ?? EmptyView().eraseToAnyView()
		}
	}

	private func createActionButton(for action: TopBarAction) -> AnyView {
		Button(action: action.action) {
			Image(action.icon).scaledToFit().frame(width: 30).foregroundColor(.primary)
				.accessibilityLabel(action.title ?? LocalizedStringKey(action.icon))
			if let title = action.title {
				Text(title)
					.lineLimit(1)
					.font(.caption)
					.bold()
					.accessibilityHidden(true)
			}
		}
		.accessibility(label: Text(action.title ?? LocalizedStringKey(action.icon)))
		.eraseToAnyView()
	}
}
