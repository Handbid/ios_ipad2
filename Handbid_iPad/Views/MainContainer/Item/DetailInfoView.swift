// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DetailInfoView: View {
	@Binding var isVisible: Bool
	let resetTimer: () -> Void
	let item: ItemModel
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			HStack {
				Spacer()
				Text(item.categoryName ?? "NaN")
					.fontWeight(.light)
					.font(.callout)
					.accessibilityIdentifier("categoryName")
				Text(" | ")
					.foregroundColor(.gray)

				let formattedItemCode = item.itemCode.map { code in
					code.hasPrefix("#") ? code : "#\(code)"
				} ?? "NaN"

				Text("\(formattedItemCode)")
					.fontWeight(.light)
					.font(.callout)
					.accessibilityIdentifier("itemID")
				Text(" | ")
					.foregroundColor(.gray)
				Text("\(item.bidCount ?? -1) bids")
					.foregroundColor(.accentViolet)
					.fontWeight(.light)
					.font(.callout)
					.accessibilityIdentifier("bidCount")
				Spacer()
			}
			HStack {
				Spacer()
				Text(item.name ?? "NaN")
					.font(.title)
					.fontWeight(.medium)
					.multilineTextAlignment(.center)
					.accessibilityIdentifier("itemDescription")
				Spacer()
			}

			HStack(spacing: 10) {
				Spacer()
				VStack(alignment: .leading) {
					Text("VALUE")
						.font(.subheadline)
						.foregroundColor(.gray)
						.fontWeight(.light)
					Text("\(item.value ?? -1, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
						.font(.subheadline)
						.fontWeight(.bold)
						.accessibilityIdentifier("itemValue")
				}

				VStack {
					Rectangle()
						.foregroundColor(.gray)
						.frame(width: 1)
						.padding(.vertical, 4)
				}

				VStack(alignment: .leading) {
					Text("INCREMENT")
						.font(.subheadline)
						.foregroundColor(.gray)
						.fontWeight(.light)
					Text("\(item.bidIncrement ?? -1.0, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
						.font(.subheadline)
						.fontWeight(.bold)
						.accessibilityIdentifier("bidIncrement")
				}
				VStack {
					Rectangle()
						.foregroundColor(.gray)
						.frame(width: 1)
						.padding(.vertical, 4)
				}
				VStack(alignment: .trailing) {
					Text("BUY NOW")
						.font(.subheadline)
						.foregroundColor(.gray)
						.fontWeight(.light)
					Text("\(item.buyNowPrice ?? -1, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
						.font(.subheadline)
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
