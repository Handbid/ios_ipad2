// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SearchItemsView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject var searchItemsViewModel: SearchItemsViewModel
	@StateObject var deviceContext = DeviceContext()

	var body: some View {
		VStack(spacing: 0) {
			topBarContent(for: .searchItems)
				.accessibility(identifier: "topBar")
			GeometryReader { _ in
			}
		}
		.navigationBarBackButtonHidden()
	}

	private func topBarContent(for viewType: MainContainerTypeSubPagesView) -> some View {
		switch viewType {
		case .searchItems:
			AnyView(GenericTopBarContentFactory(viewModel: searchItemsViewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo())
		}
	}
}
