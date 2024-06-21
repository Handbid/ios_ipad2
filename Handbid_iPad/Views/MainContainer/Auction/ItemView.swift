// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ItemView: View {
	@Environment(\.colorScheme) var colorScheme
	var item: ItemModel
	var currencyCode: String

	var body: some View {
		ZStack(alignment: .topTrailing) {
			RoundedRectangle(cornerRadius: 40.0)
				.foregroundStyle(.itemBackground)
				.shadow(color: .itemShadow, radius: 10, x: 0, y: 2)

			itemContent

			if item.isLive == true || item.isDirectPurchaseItem == true {
				itemBadge
					.padding([.trailing, .top], 20)
			}
		}
		.frame(width: 337)
		.padding(.all, 12)
	}

	private var itemContent: some View {
		VStack {
			AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaledToFit()
						.frame(height: 187, alignment: .center)
				case let .success(image):
					image.resizable()
						.aspectRatio(contentMode: .fit)
						.scaledToFill()
						.frame(height: 187, alignment: .center)
						.cornerRadius(32)
				case .failure:
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
						.foregroundColor(colorScheme == .dark ? .white : .gray)
						.frame(height: 187, alignment: .center)
						.padding()
				@unknown default:
					EmptyView()
				}
			}
			.padding([.bottom], 10)

			HStack {
				Text(item.categoryName ?? "NaN")
					.applyTextStyle(style: .leadingLabel)

				Divider()

				if let itemCode = item.itemCode {
					Text(itemCode.starts(with: "#") ? itemCode : "#\(itemCode)")
						.applyTextStyle(style: .leadingLabel)
				}

				if item.isDirectPurchaseItem == false, item.isAppeal == false, item.isTicket == false {
					Divider()

					let format = String(localized: "item_label_numberOfBids")
					let label = String(format: format, item.bidCount ?? -1)

					Text(label)
						.applyTextStyle(style: .accentBody)
				}

				Spacer()
			}
			.frame(height: 20)
			.padding(.all, 0)
			.lineLimit(2)

			Text(item.name ?? "NaN")
				.applyTextStyle(style: .titleLeading)

			Text(item.currentPrice ?? -1, format: .currency(code: currencyCode))
				.applyTextStyle(style: .subheader)
		}
		.padding(.vertical, 16)
		.padding(.horizontal, 16)
	}

	private var itemBadge: some View {
		Text(String(localized: item.isLive == true ? "item_label_live" :
				item.isDirectPurchaseItem == true ? "item_label_forSale" : ""))
			.textCase(.uppercase)
			.foregroundStyle(.white)
			.padding()
			.frame(height: 24)
			.background {
				RoundedRectangle(cornerRadius: 30.0)
					.foregroundStyle(item.isLive == true ? .statusSuccess :
						item.isDirectPurchaseItem == true ? .accent : .black
					)
			}
	}
}
