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
		.frame(width: 337, height: 400) // Stała wysokość dla ItemView
		.padding(.all, 12)
	}

	private var itemContent: some View {
		VStack(spacing: 8) { // Użycie spacing dla regulacji odstępów
			AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
				switch phase {
				case .empty:
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
						.foregroundColor(colorScheme == .dark ? .white : .gray)
						.frame(height: 187, alignment: .center)
						.accessibilityIdentifier("ImageLoadingIndicator")
						.padding()
				case let .success(image):
					image.resizable()
						.aspectRatio(contentMode: .fit)
						.scaledToFill()
						.frame(height: 187, alignment: .center)
						.cornerRadius(32)
						.accessibilityIdentifier("ItemImage")
				case .failure:
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
						.foregroundColor(colorScheme == .dark ? .white : .gray)
						.frame(height: 187, alignment: .center)
						.padding()
						.accessibilityIdentifier("ItemImagePlaceholder")
				@unknown default:
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaledToFit()
						.frame(height: 187, alignment: .center)
				}
			}

			HStack {
				Text(item.categoryName ?? "NaN")
					.applyTextStyle(style: .leadingLabel)
					.accessibilityIdentifier("CategoryName")

				Divider()

				if let itemCode = item.itemCode {
					Text(itemCode.starts(with: "#") ? itemCode : "#\(itemCode)")
						.applyTextStyle(style: .leadingLabel)
						.accessibilityIdentifier("ItemCode")
				}

				if item.isDirectPurchaseItem == false, item.isAppeal == false, item.isTicket == false {
					Divider()

					let format = String(localized: "item_label_numberOfBids")
					let label = String(format: format, item.bidCount ?? -1)

					Text(label)
						.applyTextStyle(style: .accentBody)
						.accessibilityIdentifier("NumberOfBids")
				}

				Spacer()
			}
			.frame(height: 20)
			.lineLimit(1)
			.padding(.all, 0)

			Text(item.name ?? "NaN")
				.applyTextStyle(style: .titleLeading)
				.frame(maxHeight: 60)
				.lineLimit(3)
				.padding([.bottom, .top], 3)

			Text(item.currentPrice ?? -1, format: .currency(code: currencyCode))
				.applyTextStyle(style: .subheader)
				.lineLimit(1)
		}
		.padding(.vertical, 8)
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
			.accessibilityIdentifier("ItemBadge")
	}
}
