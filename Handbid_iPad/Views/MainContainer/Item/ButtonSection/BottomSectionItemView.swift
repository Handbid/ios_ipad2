// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BottomSectionItemView: View {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	@State private var bidAmount: Double = 99.99
	private let initialBidAmount: Double = 99.99

	var body: some View {
		VStack(spacing: 10) {
			ZStack {
				AmountViewFactory.createAmountView(for: item, bidAmount: $bidAmount, resetTimer: resetTimer, initialBidAmount: initialBidAmount)
			}
			.frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
			.background(Color.white)
			.cornerRadius(25)
			.overlay(
				RoundedRectangle(cornerRadius: 25)
					.stroke(Color.accentGrayBorder, lineWidth: 2)
			)
			.padding([.leading, .trailing], 20)
			.padding(.top, 10)

			ButtonSectionItemFactory.createButtonView(for: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput, bidAmount: $bidAmount)
		}
		.onTapGesture {
			resetTimer()
		}
	}
}

struct ItemAmountView: View {
	@Binding var bidAmount: Double
	let resetTimer: () -> Void
	let bidIncrement: Double
	let initialBidAmount: Double

	var body: some View {
		HStack(spacing: 20) {
			Button(action: {
				resetTimer()
				decrementBid()
			}) {
				Text("-")
					.font(.title)
					.fontWeight(.bold)
					.textCase(.uppercase)
					.background(Color.clear)
					.foregroundColor(.primary)
					.clipShape(Circle())
			}
			.accessibilityIdentifier("-")

			TextField("", value: $bidAmount, format: .currency(code: "USD"))
				.multilineTextAlignment(.center)
				.accessibilityIdentifier("bidTextField")
				.frame(maxWidth: .infinity, alignment: .center)
				.disabled(true)
				.fontWeight(.bold)

			Button(action: {
				resetTimer()
				incrementBid()
			}) {
				Text("+")
					.font(.title)
					.fontWeight(.bold)
					.textCase(.uppercase)
					.background(Color.clear)
					.foregroundColor(.primary)
					.clipShape(Circle())
			}
			.accessibilityIdentifier("+")
		}
		.padding([.trailing, .leading], 20)
	}

	private func incrementBid() {
		bidAmount += bidIncrement
	}

	private func decrementBid() {
		if bidAmount > initialBidAmount {
			bidAmount -= bidIncrement
		}
	}
}

class AmountViewFactory {
	static func createAmountView(for item: ItemModel, bidAmount: Binding<Double>, resetTimer: @escaping () -> Void, initialBidAmount: Double) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderAmountView(bidAmount: bidAmount, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutAmountView(bidAmount: bidAmount, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		case .normal:
			AnyView(NormalAmountView(bidAmount: bidAmount, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		default:
			AnyView(DefaultAmountView(bidAmount: bidAmount, resetTimer: resetTimer, initialBidAmount: initialBidAmount))
		}
	}
}

protocol AmountItemViewProtocol: View {
	init(bidAmount: Binding<Double>, resetTimer: @escaping () -> Void, initialBidAmount: Double)
}

struct DefaultAmountView: AmountItemViewProtocol {
	@Binding var bidAmount: Double
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		ItemAmountView(bidAmount: $bidAmount, resetTimer: resetTimer, bidIncrement: 1.0, initialBidAmount: initialBidAmount)
	}
}

struct PlaceOrderAmountView: AmountItemViewProtocol {
	@Binding var bidAmount: Double
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		ItemAmountView(bidAmount: $bidAmount, resetTimer: resetTimer, bidIncrement: 2.0, initialBidAmount: initialBidAmount)
	}
}

struct PlaceOrderSoldOutAmountView: AmountItemViewProtocol {
	@Binding var bidAmount: Double
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		ItemAmountView(bidAmount: $bidAmount, resetTimer: resetTimer, bidIncrement: 1.5, initialBidAmount: initialBidAmount)
	}
}

struct NormalAmountView: AmountItemViewProtocol {
	@Binding var bidAmount: Double
	let resetTimer: () -> Void
	let initialBidAmount: Double

	var body: some View {
		ItemAmountView(bidAmount: $bidAmount, resetTimer: resetTimer, bidIncrement: 1.0, initialBidAmount: initialBidAmount)
	}
}

class ButtonSectionItemFactory {
	static func createButtonView(for item: ItemModel, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>, bidAmount: Binding<Double>) -> AnyView {
		switch item.itemType {
		case .placeOrder:
			AnyView(PlaceOrderButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .placeOrderSoldOut:
			AnyView(PlaceOrderSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .normal:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .liveAuction:
			AnyView(LiveAuctionButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .biddingDisabled:
			AnyView(BiddingDisabledButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .buyNow:
			AnyView(BuyNowButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .buyNowSoldOut:
			AnyView(BuyNowSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .directPurchaseEventOnly:
			AnyView(DirectPurchaseEventOnlyButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .directPurchase:
			AnyView(DirectPurchaseButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .directPurchaseSoldOut:
			AnyView(DirectPurchaseSoldOutButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .puzzle:
			AnyView(PuzzleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .forSale:
			AnyView(ForSaleButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .normalSold:
			AnyView(NormalButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		case .none:
			AnyView(DefaultButtonView(item: item, resetTimer: resetTimer, showPaddleInput: showPaddleInput, bidAmount: bidAmount))
		}
	}
}

protocol ButtonItemViewProtocol: View {
	init(item: ItemModel, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>, bidAmount: Binding<Double>)
}

struct DefaultButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Confirm")
					.textCase(.uppercase)
			}
			.accessibilityIdentifier("Confirm")
		}
		.padding()
	}
}

import SwiftUI

// Widok dla ItemPlaceOrder
struct PlaceOrderButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			if item.itemStatus == .pending {}

			Text("PLACE AN ORDER")

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Place Order")
			}
			Text("Bid Amount: \(bidAmount, specifier: "%.2f")")
			// Add more specific UI and logic for PlaceOrder state
		}
		.padding()
	}
}

// Widok dla ItemPlaceOrderSoldOut
struct PlaceOrderSoldOutButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Sold Out")
			}
			// Add more specific UI and logic for PlaceOrderSoldOut state
		}
		.padding()
	}
}

// Widok dla ItemNormal
struct NormalButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Bid Now")
			}
			// Add more specific UI and logic for Normal state
		}
		.padding()
	}
}

// Widok dla ItemNormalSold
struct NormalSoldButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Item Sold")
			}
			// Add more specific UI and logic for NormalSold state
		}
		.padding()
	}
}

// Widok dla ItemBiddingDisabled
struct BiddingDisabledButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Bidding Disabled")
			}
			// Add more specific UI and logic for BiddingDisabled state
		}
		.padding()
	}
}

// Widok dla ItemBuyNow
struct BuyNowButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Buy Now for \(item.buyNowPrice)")
			}
			// Add more specific UI and logic for BuyNow state
		}
		.padding()
	}
}

// Widok dla ItemBuyNowSoldOut
struct BuyNowSoldOutButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Sold Out")
			}
			// Add more specific UI and logic for BuyNowSoldOut state
		}
		.padding()
	}
}

// Widok dla ItemLiveAuction
struct LiveAuctionButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Live Auction")
			}
			// Add more specific UI and logic for LiveAuction state
		}
		.padding()
	}
}

// Widok dla ItemDirectPurchaseEventOnly
struct DirectPurchaseEventOnlyButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Event Only Purchase")
			}
			// Add more specific UI and logic for DirectPurchaseEventOnly state
		}
		.padding()
	}
}

// Widok dla ItemDirectPurchase
struct DirectPurchaseButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Direct Purchase")
			}
			// Add more specific UI and logic for DirectPurchase state
		}
		.padding()
	}
}

// Widok dla ItemDirectPurchaseSoldOut
struct DirectPurchaseSoldOutButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Sold Out")
			}
			// Add more specific UI and logic for DirectPurchaseSoldOut state
		}
		.padding()
	}
}

// Widok dla ItemPuzzle
struct PuzzleButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Buy Puzzle Piece for \(item.buyNowPrice)")
			}
			// Add more specific UI and logic for Puzzle state
		}
		.padding()
	}
}

struct ForSaleButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var bidAmount: Double

	var body: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Buy Puzzle Piece for \(item.buyNowPrice)")
			}
			// Add more specific UI and logic for Puzzle state
		}
		.padding()
	}
}
