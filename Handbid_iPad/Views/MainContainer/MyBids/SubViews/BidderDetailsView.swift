// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct BidderDetailsView: View {
	@StateObject var viewModel: MyBidsViewModel
	@FocusState var focusedField: Field?
	var inspection = Inspection<Self>()

	var body: some View {
		content
	}

	private var content: some View {
		GeometryReader { geometry in
			HStack(spacing: 0) {
				leftColumn
					.frame(width: geometry.size.width * 0.6)
					.padding()
					.onAppear {
						viewModel.requestFetchBids()
					}

				rightColumn
					.frame(width: geometry.size.width * 0.4)
					.padding()
			}
			.frame(width: geometry.size.width, height: geometry.size.height)
		}
		.padding([.leading, .trailing], 40)
		.edgesIgnoringSafeArea(.all)
	}

	// MARK: - Left Column

	private var leftColumn: some View {
		LoadingOverlay(isLoading: $viewModel.isLoadingBids, backgroundColor: .clear) {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					VStack(alignment: .leading, spacing: 5) {
						Text(viewModel.selectedBidder?.name ?? "")
							.font(.title)
							.fontWeight(.bold)
						Text("Paddle #\(viewModel.selectedBidder?.currentPaddleNumber ?? -1)")
							.font(.subheadline)
							.foregroundColor(.black)
					}
					VStack(spacing: 15) {
						expandableSection(
							title: "Winning",
							count: viewModel.winningItems.count,
							total: viewModel.winningTotal,
							isExpanded: $viewModel.isWinningExpanded
						) {
							VStack(spacing: 0) {
								ForEach(Array(viewModel.winningItems.enumerated()), id: \.element.id) { index, bid in
									HStack {
										AsyncImage(url: URL(string: bid.item?.imageUrl ?? "")) { image in
											image
												.resizable()
												.aspectRatio(contentMode: .fill)
										} placeholder: {
											Image("default_photo")
										}
										.frame(width: 40, height: 40)
										.cornerRadius(8)

										Text(bid.item?.name ?? "")
											.padding(.all, 20)
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.headline)
											.fontWeight(.regular)
											.multilineTextAlignment(.leading)
									}
									.padding(.leading, 20)
									.background(Color.white)

									if index < viewModel.winningItems.count - 1 {
										Divider()
											.background(Color.accentGrayBackground)
											.padding([.leading, .trailing], 20)
									}
								}
							}
						}
						.cornerRadius(8)
					}

					expandableSection(
						title: "Losing",
						count: viewModel.losingItems.count,
						total: viewModel.losingTotal,
						isExpanded: $viewModel.isLosingExpanded
					) {
						VStack(spacing: 0) {
							ForEach(Array(viewModel.losingItems.enumerated()), id: \.element.id) { index, bid in
								HStack {
									AsyncImage(url: URL(string: bid.item?.imageUrl ?? "")) { image in
										image
											.resizable()
											.aspectRatio(contentMode: .fill)
									} placeholder: {
										Image("default_photo")
									}
									.frame(width: 40, height: 40)
									.cornerRadius(8)

									Text(bid.item?.name ?? "")
										.padding(.all, 20)
										.frame(maxWidth: .infinity, alignment: .leading)
										.font(.headline)
										.fontWeight(.regular)
										.multilineTextAlignment(.leading)
								}
								.padding(.leading, 20)
								.background(Color.white)

								if index < viewModel.losingItems.count - 1 {
									Divider()
										.background(Color.accentGrayBackground)
										.padding([.leading, .trailing], 20)
								}
							}
						}
						.cornerRadius(8)
					}

					expandableSection(
						title: "Purchased",
						count: viewModel.purchasedItems.count,
						total: viewModel.purchasedTotal,
						isExpanded: $viewModel.isPurchasedExpanded
					) {
						VStack(spacing: 0) {
							ForEach(Array(viewModel.purchasedItems.enumerated()), id: \.element.id) { index, bid in
								HStack {
									AsyncImage(url: URL(string: bid.item?.imageUrl ?? "")) { image in
										image
											.resizable()
											.aspectRatio(contentMode: .fill)
									} placeholder: {
										Image("default_photo")
									}
									.frame(width: 40, height: 40)
									.cornerRadius(8)

									Text(bid.item?.name ?? "")
										.padding(.all, 20)
										.frame(maxWidth: .infinity, alignment: .leading)
										.font(.headline)
										.fontWeight(.regular)
										.multilineTextAlignment(.leading)
								}
								.padding(.leading, 20)
								.background(Color.white)

								if index < viewModel.purchasedItems.count - 1 {
									Divider()
										.background(Color.accentGrayBackground)
										.padding([.leading, .trailing], 20)
								}
							}
						}
						.cornerRadius(8)
					}
				}
			}
		}
	}

	// MARK: - Expand Section

	@ViewBuilder
	private func expandableSection<Content: View>(
		title: String,
		count: Int,
		total: String,
		isExpanded: Binding<Bool>,
		@ViewBuilder content: () -> Content
	) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(title)
					.font(.headline)

				ZStack {
					Circle()
						.fill(title == "Winning" ? Color.green :
							title == "Losing" ? Color.red : Color.yellow)
						.frame(width: 24, height: 24)
					Text("\(count)")
						.foregroundColor(.white)
						.font(.caption)
						.fontWeight(.bold)
				}

				Spacer()

				Text(total)
					.font(.headline)
					.foregroundColor(.black)
					.fontWeight(.bold)
				Button(action: {
					withAnimation {
						isExpanded.wrappedValue.toggle()
					}
				}) {
					Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
						.foregroundColor(.black)
						.fontWeight(.bold)
				}
			}
			.padding()
			.background(Color.white)
			.cornerRadius(8)

			if isExpanded.wrappedValue {
				content()
					.padding(.top, 10)
			}
		}
	}

	// MARK: - Right Column

	private var rightColumn: some View {
		VStack(alignment: .leading, spacing: 20) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {}, label: {
				Text("VIEW INVOICE")
					.textCase(.uppercase)
			})

			VStack(alignment: .leading, spacing: 10) {
				Text("Credit Cards")
					.font(.title2)
					.fontWeight(.bold)
					.padding(.bottom, 5)

				VStack(spacing: 10) {
					ForEach(viewModel.selectedBidder?.creditCards ?? .init()) { card in
						HStack {
							if let cardType = card.cardType {
								Image(cardType.imageName)
									.resizable()
									.scaledToFit()
									.frame(width: 30, height: 20)
							}

							Text("\(card.cardType?.rawValue ?? "") *\(card.lastFour ?? "")")
								.frame(maxWidth: .infinity, alignment: .leading)
								.font(.subheadline)
								.fontWeight(.bold)
								.multilineTextAlignment(.leading)

							Spacer()

							Button(action: {
								viewModel.creditCards.removeAll { $0.id == card.id }
							}) {
								Text("Delete")
									.applyTextStyle(style: .error)
									.font(.subheadline)
									.fontWeight(.bold)
							}
							.fixedSize()
						}
						.padding(.vertical, 5)
						.background(Color(UIColor.systemBackground))
					}
				}

				Button<Text>.styled(config: .fifthButtonStyle, action: {
					// viewModel.addNewCard()
					viewModel.requestFetchBids()
				}, label: {
					Text("ADD NEW CARD")
						.textCase(.uppercase)
				})
			}
			.padding()
			.background(Color.white)
			.cornerRadius(8)

			Spacer()
		}
	}
}
