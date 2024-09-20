// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ItemView: View {
	@Environment(\.colorScheme) var colorScheme
	var item: ItemModel
	var currencyCode: String
	var viewWidth: CGFloat
	var viewHeight: CGFloat

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
		.frame(width: viewWidth, height: viewHeight)
		.padding(.all, 12)
	}

	private var itemContent: some View {
		let imageWidth = viewWidth * (255 / 337)
		let imageHeight = viewHeight * (173 / 397)

		return VStack(spacing: 8) {
			ZStack {
				Rectangle()
					.fill(Color.accentGrayBackground)
					.frame(width: viewWidth, height: viewHeight * (228 / 397))
					.cornerRadius(32)

				AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
					switch phase {
					case .empty:
						Image("default_photo")
							.resizable()
							.scaledToFit()
							.foregroundColor(colorScheme == .dark ? .white : .gray)
							.frame(width: imageWidth, height: imageHeight, alignment: .center)
							.accessibilityIdentifier("ImageLoadingIndicator")
							.padding()
					case let .success(image):
						image.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: viewWidth, height: viewHeight * (228 / 397))
							.clipped()
							.cornerRadius(32)
							.accessibilityIdentifier("ItemImage")
					case .failure:
						Image("default_photo")
							.resizable()
							.scaledToFit()
							.foregroundColor(colorScheme == .dark ? .white : .gray)
							.frame(width: imageWidth, height: imageHeight, alignment: .center)
							.padding()
							.accessibilityIdentifier("ItemImagePlaceholder")
					@unknown default:
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle())
							.scaledToFit()
							.frame(width: imageWidth, height: imageHeight, alignment: .center)
					}
				}
				.frame(width: imageWidth, height: imageHeight)
			}
			.frame(width: viewWidth, height: viewHeight * (228 / 397))

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
				.accessibilityIdentifier("ItemName")

			Text(item.currentPrice ?? -1, format: .currency(code: currencyCode))
				.applyTextStyle(style: .subheader)
				.lineLimit(1)
				.accessibilityIdentifier("CurrentPrice")
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
