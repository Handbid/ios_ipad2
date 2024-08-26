// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CategoryView: View {
	let category: CategoryModel
	let onItemSelect: (ItemModel) -> Void
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var body: some View {
		VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding()
				.accessibilityIdentifier("categoryName")
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(category.items ?? [], id: \.id) { item in
						ItemView(item: item, currencyCode: "\(auction?.currencyCode ?? "")", viewWidth: 337, viewHeight: 397)
							.onTapGesture {
								onItemSelect(item)
							}
							.accessibilityIdentifier("itemView")
					}
					.padding()
				}
			}
			.scrollIndicators(.never)
			.defaultScrollAnchor(.leading)
			.frame(height: 397 + 24)
		}
		.accessibilityIdentifier("categoryView")
	}
}
