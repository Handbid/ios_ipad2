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

			AsyncImage(url: auction.imageUrl) { phase in
				switch phase {
				case .empty:
					ProgressView()
				case let .success(image):
					image.resizable().aspectRatio(contentMode: .fill)
				case .failure:
					Image(systemName: "photo.on.rectangle.angled") // Default image on failure
						.resizable()
						.aspectRatio(contentMode: .fit)
						.padding()
				@unknown default:
					EmptyView()
				}
			}
			.frame(height: 200) // Set a fixed height for the image within the cell

			Text(auction.name)
				.bold()

			Text(auction.address)
			Text("Ends on \(auction.endDate)")
		}
		.padding()
		.frame(width: 307, height: 370)
		.background(Color.white)
		.cornerRadius(10)
		.shadow(radius: 5)
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
	//    @Environment(\.deviceOrientation) private var deviceOrientation // Custom environment value if needed

	@State private var selectedView: SelectAuctionContainerTypeView
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
				TopBar(content: topBarContent(for: selectedView), barHeight: 60)
					.frame(height: 60)

				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 10) {
						ForEach(AuctionState.allCases, id: \.self) { state in
							AuctionButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state) {
								viewModel.filterAuctions()
							}
						}
					}
					.padding(.horizontal)
					.padding(.bottom, 10)
				}

				ScrollView {
					LazyVGrid(columns: columns, spacing: 20) {
						ForEach(viewModel.filteredAuctions, id: \.id) { auction in
							AuctionItemView(auction: auction)
								.frame(width: cellWidth, height: cellHeight)
						}
					}
					.padding()
				}

				Spacer()
			}
		}
	}

	private func createGridItems(width: CGFloat, targetWidth: CGFloat) -> [GridItem] {
		let numberOfColumns = max(Int(width / targetWidth), 1)
		return Array(repeating: GridItem(.fixed(targetWidth), spacing: 20), count: numberOfColumns)
	}

	private func topBarContent(for viewType: SelectAuctionContainerTypeView) -> TopBarContent {
		switch viewType {
		case .selectAuction:
			GenericTopBarContentFactory(viewModel: viewModel, deviceContext: deviceContext).createTopBarContentWithoutLogo()
		}
	}
}
