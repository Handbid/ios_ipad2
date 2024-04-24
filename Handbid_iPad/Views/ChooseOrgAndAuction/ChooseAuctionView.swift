// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum AuctionState: String, CaseIterable {
	case open, presale, preview, closed, reconciled, all

	var color: Color {
		switch self {
		case .open, .all: Color.green
		case .presale: Color.pink
		case .preview: Color.orange
		case .closed: Color.red
		case .reconciled: Color.blue
		}
	}
}

class AuctionButtonViewModel: ObservableObject {
	@Published var isSelected: Bool = false
}

struct AuctionButtonView: View {
	@ObservedObject var viewModel: AuctionButtonViewModel
	let auctionState: AuctionState

	var body: some View {
		Button(action: {
			viewModel.isSelected.toggle()
		}) {
			HStack {
				Circle()
					.fill(auctionState.color)
					.frame(width: 40, height: 40)
					.overlay(
						Image(systemName: "checkmark")
							.foregroundColor(viewModel.isSelected ? .white : .clear)
					)
				Text(auctionState.rawValue.capitalized)
					.font(.caption)
					.foregroundColor(.black)
			}
		}
	}
}

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

			HStack(spacing: 10) {
				ForEach(AuctionState.allCases, id: \.self) { state in
					AuctionButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state)
				}
			}
			.padding()

			Spacer()
		}
		.background(Color.gray)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> TopBarContent {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
