// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseAuctionViewModel
	@State private var selectedView: SelectAuctionContainerTypeView
	@State private var isBlurred = false
	private var deviceContext = DeviceContext()
	var inspection = Inspection<Self>()

	init(viewModel: ChooseAuctionViewModel, selectedView: SelectAuctionContainerTypeView) {
		self.viewModel = viewModel
		self.selectedView = selectedView
	}

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView), barHeight: 60)
			Spacer()

			//            GeometryReader { geometry in
			//                if deviceContext.isPhone {
			//                    phoneView(geometry: geometry)
			//                }
			//                else {
			//                    tabletView(geometry: geometry)
			//                }
			//            }
		}
		.background(Color.red)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> TopBarContent {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
