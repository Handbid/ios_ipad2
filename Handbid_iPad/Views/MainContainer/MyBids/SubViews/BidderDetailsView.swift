// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct BidderDetailsView: View {
	@StateObject var viewModel: MyBidsViewModel
	@FocusState var focusedField: Field?
	@State private var isShowingInvoice = false
	var inspection = Inspection<Self>()
	@EnvironmentObject var mainContainerViewModel: MainContainerViewModel

	private var isWinningExpandedBinding: Binding<Bool> {
		Binding(
			get: { viewModel.isWinningExpanded },
			set: { viewModel.isWinningExpanded = $0 }
		)
	}

	private var isLosingExpandedBinding: Binding<Bool> {
		Binding(
			get: { viewModel.isLosingExpanded },
			set: { viewModel.isLosingExpanded = $0 }
		)
	}

	private var isPurchasedExpandedBinding: Binding<Bool> {
		Binding(
			get: { viewModel.isPurchasedExpanded },
			set: { viewModel.isPurchasedExpanded = $0 }
		)
	}

	var body: some View {
		ZStack {
			LoadingOverlay(isLoading: $viewModel.isLoadingBids, backgroundColor: .clear) {
				content
			}
		}
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
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 20) {
				bidderInfo
				itemsSection
			}
		}
	}

	private var bidderInfo: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(viewModel.selectedBidder?.name ?? "")
				.font(.title)
				.fontWeight(.bold)
			Text("Paddle #\(viewModel.selectedBidder?.currentPaddleNumber ?? -1)")
				.font(.subheadline)
				.foregroundColor(.black)
		}
	}

	private var itemsSection: some View {
		VStack(spacing: 15) {
			expandableSectionForItems(
				title: "Winning",
				items: viewModel.winningItems,
				total: viewModel.winningTotal,
				isExpanded: isWinningExpandedBinding
			)

			expandableSectionForItems(
				title: "Losing",
				items: viewModel.losingItems,
				total: viewModel.losingTotal,
				isExpanded: isLosingExpandedBinding
			)

			expandableSectionForItems(
				title: "Purchased",
				items: viewModel.purchasedItems,
				total: viewModel.purchasedTotal,
				isExpanded: isPurchasedExpandedBinding
			)
		}
	}

	// MARK: - Expandable Section

	@ViewBuilder
	private func expandableSectionForItems(
		title: String,
		items: [BidModel],
		total: String,
		isExpanded: Binding<Bool>
	) -> some View {
		expandableSection(
			title: title,
			count: items.count,
			total: total,
			isExpanded: isExpanded
		) {
			VStack(spacing: 0) {
				ForEach(items, id: \.id) { bid in
					itemRow(bid: bid)
					if bid.id != items.last?.id {
						Divider()
							.background(Color.accentGrayBackground)
							.padding([.leading, .trailing], 20)
					}
				}
			}
			.cornerRadius(8)
		}
	}

	private func itemRow(bid: BidModel) -> some View {
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
				.font(.subheadline)
				.fontWeight(.semibold)
				.multilineTextAlignment(.leading)

			Spacer()

			Text(bid.item?.currentPrice ?? -1, format: .currency(code: viewModel.selectedBidder?.currency ?? ""))
				.padding(.trailing, 10)
				.font(.caption)
				.fontWeight(.regular)
				.multilineTextAlignment(.trailing)
		}
		.padding(.leading, 20)
		.background(Color.white)
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
						.fill(viewModel.colorForSection(title: title))
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
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				withAnimation {
					mainContainerViewModel.invoiceViewModel = InvoiceViewModel(
						myBidsViewModel: viewModel
					)
					mainContainerViewModel.displayedOverlay = .invoiceView
				}
			}, label: {
				Text("VIEW INVOICE")
					.textCase(.uppercase)
			})

			if viewModel.selectedBidder?.isCheckedIn?.description == "N" {
				Button<Text>.styled(config: .primaryButtonStyle, action: {
					viewModel.checkIn()
				}, label: {
					Text("CHECK IN")
						.textCase(.uppercase)
				})
			}

			creditCardsSection

			Spacer()
		}
	}

	// MARK: - Credit Cards Section

	private var creditCardsSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Credit Cards")
				.font(.title2)
				.fontWeight(.bold)
				.padding(.bottom, 5)

			VStack(spacing: 10) {
				ForEach(viewModel.selectedBidder?.creditCards ?? []) { card in
					creditCardRow(card: card)
				}
			}

			Button<Text>.styled(config: .fifthButtonStyle, action: {
                viewModel.showAddCardAlert()
			}, label: {
				Text("ADD NEW CARD")
					.textCase(.uppercase)
			})
		}
		.padding()
		.background(Color.white)
		.cornerRadius(8)
	}

	private func creditCardRow(card: CreditCardModel) -> some View {
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
				viewModel.deleteCard(withId: card.id)
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
