// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DetailInfoView: View {
	@Binding var isVisible: Bool
	let resetTimer: () -> Void
	let item: ItemModel

	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			HStack {
				Spacer()
				Text(item.categoryName ?? "NaN")
					.foregroundColor(.black)
					.fontWeight(.light)
					.font(.headline)
					.accessibilityIdentifier("categoryName")
				Text(" | ")
					.foregroundColor(.gray)

				let formattedItemCode = item.itemCode.map { code in
					code.hasPrefix("#") ? code : "#\(code)"
				} ?? "NaN"

				Text("\(formattedItemCode)")
					.foregroundColor(.black)
					.fontWeight(.light)
					.font(.headline)
					.accessibilityIdentifier("itemID")
				Text(" | ")
					.foregroundColor(.gray)
				Text("\(item.bidCount ?? -1) bids")
					.foregroundColor(.accentViolet)
					.fontWeight(.light)
					.font(.headline)
					.accessibilityIdentifier("bidCount")
				Spacer()
			}
			HStack {
				Spacer()
				Text(item.name ?? "NaN")
					.font(.title)
					.fontWeight(.bold)
					.multilineTextAlignment(.center)
					.accessibilityIdentifier("itemDescription")
				Spacer()
			}

			HStack(spacing: 30) {
				Spacer()
				VStack(alignment: .leading) {
					Text("VALUE")
						.font(.caption)
						.foregroundColor(.gray)
					Text("\(item.value ?? -1, format: .currency(code: "USD"))")
						.font(.headline)
						.fontWeight(.bold)
						.accessibilityIdentifier("itemValue")
				}
				VStack(alignment: .leading) {
					Text("INCREMENT")
						.font(.caption)
						.foregroundColor(.gray)
					Text("\(item.bidIncrement ?? -1.0, format: .number)")
						.font(.headline)
						.fontWeight(.bold)
						.accessibilityIdentifier("bidIncrement")
				}
				VStack(alignment: .trailing) {
					Text("BUY NOW")
						.font(.caption)
						.foregroundColor(.gray)
					Text("\(item.buyNowPrice ?? -1, format: .currency(code: "USD"))")
						.font(.headline)
						.fontWeight(.bold)
						.accessibilityIdentifier("buyNowPrice")
				}
				Spacer()
			}

			HTMLText(html: "\(item.description ?? "NaN")")
				.frame(maxWidth: .infinity, alignment: .leading)
				.fixedSize(horizontal: false, vertical: true)
				.onTapGesture {
					resetTimer()
				}
				.accessibilityIdentifier("itemDescription")

			Spacer()
		}
		.padding()
		.padding(.trailing, 20)
		.onTapGesture {
			resetTimer()
		}
		.frame(maxHeight: .infinity)
		.clipped()
	}
}
