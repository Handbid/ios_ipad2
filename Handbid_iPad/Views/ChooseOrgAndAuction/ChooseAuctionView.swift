// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var selectedView: SelectAuctionContainerTypeView
	@ObservedObject private var viewModel: ChooseAuctionViewModel
	private var deviceContext = DeviceContext()
	@State private var isBlurred = false
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
				GeometryReader { geometry in
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(alignment: .center) {
							HStack(spacing: 10) {
								ForEach(AuctionStateStatuses.allCases.dropLast(), id: \.self) { state in
									AuctionFilterButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state) {
										viewModel.filterAuctions()
									}
								}
							}
							Spacer()
							HStack(spacing: 10) {
								if let lastState = AuctionStateStatuses.allCases.last {
									AuctionFilterButtonView(viewModel: viewModel.buttonViewModels[lastState]!, auctionState: lastState) {
										viewModel.filterAuctions()
									}
								}
							}
						}
						.padding([.leading, .trailing], 40)
						.frame(minWidth: geometry.size.width, alignment: .leading)
						.frame(height: 50)
					}
				}
				.frame(height: 50)

				ScrollView {
					LazyVGrid(columns: columns, spacing: 20) {
						ForEach(viewModel.filteredAuctions, id: \.id) { auction in
							AuctionCollectionCellView<MainContainerPage>(auction: auction)
								.frame(width: cellWidth, height: cellHeight)
						}
					}
					.padding()
				}

				Spacer()
			}
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

	private func createGridItems(width: CGFloat, targetWidth: CGFloat) -> [GridItem] {
		let numberOfColumns = max(Int(width / targetWidth), 1)
		return Array(repeating: GridItem(.fixed(targetWidth), spacing: 20), count: numberOfColumns)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> some View {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
