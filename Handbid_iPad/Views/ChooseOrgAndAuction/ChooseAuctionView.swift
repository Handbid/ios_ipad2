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

struct AuctionItem {
	let id: UUID = .init()
	let name: String
	let address: String
	let endDate: String
	let itemCount: Int
	let status: String
	let imageUrl: URL?
}

struct AuctionItemView: View {
	let auction: AuctionItem

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Label("\(auction.itemCount)", systemImage: "number")
					.padding(5)
					.background(Color.blue)
					.cornerRadius(10)
					.foregroundColor(.white)

				Spacer()

				Text(auction.status)
					.italic()
					.foregroundColor(.gray)
			}

			AsyncImage(url: auction.imageUrl) { image in
				image.resizable()
			} placeholder: {
				Image(systemName: "photo.on.rectangle.angled").resizable()
			}
			.scaledToFit()
			.cornerRadius(10)

			Text(auction.name)
				.bold()

			Text(auction.address)
			Text("Ends on \(auction.endDate)")
		}
		.padding()
		.background(Color.white)
		.cornerRadius(10)
		.shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
	}
}

class AuctionButtonViewModel: ObservableObject {
	@Published var isSelected: Bool = false
}

struct AuctionButtonView: View {
	@ObservedObject var viewModel: AuctionButtonViewModel
	let auctionState: AuctionState
	var onSelectionChanged: () -> Void // Callback when the selection changes

	var body: some View {
		Button(action: {
			viewModel.isSelected.toggle()
			onSelectionChanged() // Notify the view model to filter auctions
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

	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible()),
	]

	var body: some View {
		VStack(spacing: 0) {
			TopBar(content: topBarContent(for: selectedView), barHeight: 60)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 10) {
					ForEach(AuctionState.allCases, id: \.self) { state in
						AuctionButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state) {
							viewModel.filterAuctions() // This will re-filter the auctions based on the latest selections
						}
					}
				}
				.padding()
			}

			ScrollView {
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(viewModel.filteredAuctions, id: \.id) { auction in
						AuctionItemView(auction: auction)
					}
				}
				.padding()
			}

			Spacer()
		}
		.background(.white)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> TopBarContent {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
