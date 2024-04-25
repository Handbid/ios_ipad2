// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum AuctionState: String, CaseIterable {
	case open, presale, preview, closed, reconciled, all

	func color(for scheme: ColorScheme) -> Color {
		switch self {
		case .open, .all:
			scheme == .dark ? .green : .green
		case .presale:
			scheme == .dark ? .purple : .pink
		case .preview:
			scheme == .dark ? .yellow : .orange
		case .closed:
			scheme == .dark ? .orange : .red
		case .reconciled:
			scheme == .dark ? .blue : .blue
		}
	}

	static func color(for status: String, in scheme: ColorScheme) -> Color {
		(AuctionState(rawValue: status)?.color(for: scheme) ?? Color.gray)
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
	@Environment(\.colorScheme) var colorScheme
	let auction: AuctionItem

	var body: some View {
		VStack(alignment: .center, spacing: 10) {
			VStack {
				HStack {
					Text("\(auction.itemCount) Items")
						.padding(10)
						.background(colorScheme == .dark ? Color.white : Color.black)
						.foregroundColor(colorScheme == .dark ? .black : .white)
						.bold()
						.cornerRadius(15)
						.frame(height: 30)

					Spacer()

					Text(auction.status.uppercased())
						.bold()
						.foregroundColor(AuctionState.color(for: auction.status, in: colorScheme))
				}
				.padding([.leading, .trailing], 10)
			}
			.frame(height: 50)

			Spacer(minLength: 0)

			AsyncImage(url: auction.imageUrl) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaleEffect(1.5)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				case let .success(image):
					image.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 150, height: 150, alignment: .center)
				case .failure:
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
						.foregroundColor(colorScheme == .dark ? .white : .gray)
						.frame(width: 150, height: 150, alignment: .center)
						.padding()
				@unknown default:
					EmptyView()
				}
			}
			.frame(height: 150)

			VStack(spacing: 10) {
				Text(auction.name)
					.font(.headline)
					.bold()
					.lineLimit(3)
					.multilineTextAlignment(.center)
					.truncationMode(.tail)

				Text(auction.address)
					.font(.subheadline)
					.foregroundColor(colorScheme == .dark ? .white : Color.gray)
					.bold()
					.lineLimit(2)
					.multilineTextAlignment(.center)
					.truncationMode(.tail)

				HStack {
					Spacer()
					Image(systemName: "clock")
					Text("\(auction.endDate)")
						.font(.caption)
						.foregroundColor(colorScheme == .dark ? .white : Color.gray)
					Spacer()
				}
			}
			.frame(height: 100)
			.frame(maxWidth: .infinity)

			Spacer(minLength: 0)
		}
		.padding()
		.frame(width: 307, height: 370)
		.background(colorScheme == .dark ? Color.black : Color.white)
		.cornerRadius(40)
		.shadow(color: Color.accentGrayBorder.opacity(0.6), radius: 10, x: 0, y: 2)
	}
}

class AuctionButtonViewModel: ObservableObject {
	@Published var isSelected: Bool = false
}

struct AuctionButtonView: View {
	@Environment(\.colorScheme) var colorScheme
	@ObservedObject var viewModel: AuctionButtonViewModel
	let auctionState: AuctionState
	var onSelectionChanged: () -> Void

	var body: some View {
		Button(action: {
			viewModel.isSelected.toggle()
			onSelectionChanged()
		}) {
			HStack {
				Circle()
					.strokeBorder(Color.gray, lineWidth: viewModel.isSelected ? 0 : 1)
					.background(
						Circle().fill(viewModel.isSelected ? auctionState.color(for: colorScheme) : Color.white)
					)
					.frame(width: 30, height: 30)
					.overlay(
						Image(systemName: "checkmark")
							.foregroundColor(viewModel.isSelected ? .white : .clear)
					)
				Text(auctionState.rawValue.capitalized)
					.font(.caption)
					.foregroundColor(colorScheme == .dark ? .white : .black)
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

	private let cellWidth: CGFloat = 307
	private let cellHeight: CGFloat = 370

	var body: some View {
		GeometryReader { geometry in
			let columns = createGridItems(width: geometry.size.width, targetWidth: cellWidth)

			VStack(spacing: 0) {
				TopBar(content: topBarContent(for: selectedView), barHeight: 60)

				GeometryReader { geometry in
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(alignment: .center) {
							HStack(spacing: 10) {
								ForEach(AuctionState.allCases.dropLast(), id: \.self) { state in
									AuctionButtonView(viewModel: viewModel.buttonViewModels[state]!, auctionState: state) {
										viewModel.filterAuctions()
									}
								}
							}
							Spacer()
							HStack(spacing: 10) {
								if let lastState = AuctionState.allCases.last {
									AuctionButtonView(viewModel: viewModel.buttonViewModels[lastState]!, auctionState: lastState) {
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
