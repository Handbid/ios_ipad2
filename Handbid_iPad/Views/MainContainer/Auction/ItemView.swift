// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ItemView: View {
	@Environment(\.colorScheme) var colorScheme
	var item: ItemModel

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 40.0)
				.foregroundStyle(colorScheme == .dark ? .black : .white)
				.shadow(color: Color.accentGrayBorder.opacity(0.6), radius: 10, x: 0, y: 2)

			itemContent
		}
		.frame(width: 307)
		.padding()
	}

	private var itemContent: some View {
		VStack {
			AsyncImage(url: URL(string: item.imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png")) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
				case let .success(image):
					image.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 255, height: 187, alignment: .center)
						.cornerRadius(32)
				case .failure:
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
						.foregroundColor(colorScheme == .dark ? .white : .gray)
						.frame(width: 255, height: 187, alignment: .center)
						.padding()
				@unknown default:
					EmptyView()
				}
			}
			.padding([.bottom], 10)

			HStack {
				Text(item.categoryName ?? "NaN")
					.applyTextStyle(style: .body)

				Divider()

				Text("#\(item.itemCode ?? "NaN")")
					.applyTextStyle(style: .body)

				if !item.isDirectPurchaseItem!, !item.isAppeal!, !item.isTicket! {
					Divider()

					let format = String(localized: "item_label_numberOfBids")
					let label = String(format: format, item.bidCount ?? -1)

					Text(label)
						.applyTextStyle(style: .accentBody)
				}

				Spacer()
			}

			Text(item.name ?? "NaN")
				.applyTextStyle(style: .subheader)

			Text(String(format: "$%.2f", item.currentPrice ?? -1))
		}
		.padding()
	}
}
