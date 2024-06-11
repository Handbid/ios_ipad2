// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var selectedView: SelectAuctionContainerTypeView
	@ObservedObject private var viewModel: ChooseAuctionViewModel
	@State private var isLoading = true
	@State private var isBlurred = false
	private var deviceContext = DeviceContext()
	var inspection = Inspection<Self>()

	init(viewModel: ChooseAuctionViewModel, selectedView: SelectAuctionContainerTypeView) {
		self.viewModel = viewModel
		self.selectedView = selectedView
	}

	private let cellWidth: CGFloat = 307
	private let cellHeight: CGFloat = 370

	var body: some View {
		GeometryReader { geometry in
			let columns = createGridItems(width: geometry.size.width, targetWidth: cellWidth)

			VStack(spacing: 0) {
				topBarContent(for: selectedView)
					.accessibilityIdentifier("TopBarContentProtocol")
				horizontalScrollView
					.accessibilityIdentifier("HorizontalScrollView")
				LoadingOverlay(isLoading: $isLoading, backgroundColor: .clear, opacity: 1.0) {
					ScrollView {
						LazyVGrid(columns: columns, spacing: 20) {
							ForEach(viewModel.filteredAuctions, id: \.id) { auction in
								AuctionCollectionCellView<MainContainerPage>(auction: auction)
									.frame(width: cellWidth, height: cellHeight)
									.accessibilityIdentifier("AuctionCollectionCellView_\(auction.id)")
							}
						}
						.padding()
					}
					.accessibilityIdentifier("AuctionScrollView")
				}
				Spacer()
			}
		}
		.onReceive(viewModel.$isLoading) { loading in
			isLoading = loading
		}
		.onAppear {
			viewModel.organization = coordinator.model as? OrganizationModel
			viewModel.fetchAuctionsIfNeeded()
		}
		.onChange(of: $viewModel.backToPreviewViewPressed.wrappedValue) { _, newValue in
			if newValue {
				coordinator.popToRoot()
			}
		}
		.navigationBarBackButtonHidden()
	}

	private var horizontalScrollView: some View {
		GeometryReader { geometry in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .center) {
					AuctionFilterButtonGroup(viewModel: viewModel)
				}
				.padding([.leading, .trailing], 40)
				.frame(minWidth: geometry.size.width, alignment: .leading)
				.frame(height: 50)
			}
		}
		.frame(height: 50)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> some View {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}

struct AuctionFilterButtonGroup: View {
	@ObservedObject var viewModel: ChooseAuctionViewModel

	var body: some View {
		HStack(spacing: 10) {
			ForEach(AuctionStateStatuses.allCases.dropLast(), id: \.self) { state in
				AuctionFilterButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state) {
					viewModel.filterAuctions()
				}
				.accessibilityIdentifier("FilterButton_\(state.rawValue)")
			}
		}
		Spacer()
		HStack(spacing: 10) {
			if let lastState = AuctionStateStatuses.allCases.last {
				AuctionFilterButtonView(viewModel: viewModel.buttonViewModels[lastState]!, auctionState: lastState) {
					viewModel.filterAuctions()
				}
				.accessibilityIdentifier("FilterButton_\(lastState.rawValue)")
			}
		}
	}
}
