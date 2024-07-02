// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ButtonSectionItemView: View {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	var body: some View {
		VStack(spacing: 10) {
			ZStack {
				HStack(spacing: 20) {
					Button(action: {
						resetTimer()
					}) {
						Text("-")
							.textCase(.uppercase)
							.background(Color.clear)
							.foregroundColor(.primary)
							.clipShape(Circle())
					}
					.accessibilityIdentifier("-")

					TextField("", text: .constant("$99,99"))
						.multilineTextAlignment(.center)
						.accessibilityIdentifier("bidTextField")
						.frame(maxWidth: .infinity, alignment: .center)

					Button(action: {
						resetTimer()
					}) {
						Text("+")
							.textCase(.uppercase)
							.background(Color.clear)
							.foregroundColor(.primary)
							.clipShape(Circle())
					}
					.accessibilityIdentifier("+")
				}
				.padding([.trailing, .leading], 20)
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

			switch item.itemType {
			case .placeOrder, .placeOrderSoldOut, .normal, .biddingDisabled, .buyNow, .buyNowSoldOut, .liveAuction, .directPurchaseEventOnly, .directPurchase, .directPurchaseSoldOut, .puzzle, .forSale, .normalSold, .none:
				defaultButtons
			}
		}
		.onTapGesture {
			resetTimer()
		}
	}

	private var defaultButtons: some View {
		VStack {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Confirm")
					.textCase(.uppercase)
			}
			.accessibilityIdentifier("Confirm")

//			Button<Text>.styled(config: .secondaryButtonStyle, action: {
//				resetTimer()
//				showPaddleInput = true
//			}) {
//				Text("Confirm")
//					.textCase(.uppercase)
//			}
//			.accessibilityIdentifier("Confirm")
		}
		.padding()
	}
}
