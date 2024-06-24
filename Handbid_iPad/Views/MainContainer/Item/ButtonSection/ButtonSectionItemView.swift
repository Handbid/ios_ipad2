// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ButtonSectionItemView: View {
	var item: ItemModel
	let resetTimer: () -> Void

	var body: some View {
		VStack {
			if item.itemType == "forsale" {
				specialButtons
			}
			else {
				defaultButtons
			}
		}
		.padding()
		.padding(.trailing, 20)
		.onTapGesture {
			resetTimer()
		}
	}

	private var specialButtons: some View {
		VStack {
			Button(action: {
				resetTimer()
			}) {
				Text("SPECIAL BID")
					.padding()
					.frame(maxWidth: .infinity, maxHeight: 40)
					.background(Color.red)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
			.accessibilityIdentifier("specialBidButton")
		}
	}

	private var defaultButtons: some View {
		VStack {
			HStack {
				Button(action: {
					resetTimer()
				}) {
					Text("-")
						.padding()
						.frame(width: 40, height: 40)
						.background(Color(white: 0.9))
						.cornerRadius(10)
				}
				.accessibilityIdentifier("decreaseBidButton")
				TextField("", text: .constant("$99,99"))
					.padding()
					.background(Color(white: 0.9))
					.cornerRadius(10)
					.frame(width: 100, height: 40)
					.accessibilityIdentifier("bidTextField")
				Button(action: {
					resetTimer()
				}) {
					Text("+")
						.padding()
						.frame(width: 40, height: 40)
						.background(Color(white: 0.9))
						.cornerRadius(10)
				}
				.accessibilityIdentifier("increaseBidButton")
				Button(action: {
					resetTimer()
				}) {
					Text("BID NOW")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.black)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("bidNowButton")
			}
			.padding(.bottom, 10)

			HStack {
				Button(action: {
					resetTimer()
				}) {
					Text("SET MAX BID")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("setMaxBidButton")

				Button(action: {
					resetTimer()
				}) {
					Text("BUY NOW")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("buyNowButton")
			}
		}
	}
}
