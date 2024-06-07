// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionView: ContentView {
	@ObservedObject var viewModel: AuctionViewModel

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			if viewModel.categories.isEmpty {
				noItemsView
			}
			else {
				categoriesList
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.containerBackground)
		.edgesIgnoringSafeArea(.all)
	}

	private var noItemsView: some View {
		VStack {
			Spacer()

			ZStack {
				Circle()
					.stroke(Color.accentViolet.opacity(0.3), lineWidth: 1.0)
					.frame(width: 100, height: 100, alignment: .center)

				Image("noItemsIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 50, height: 50, alignment: .center)
			}
			.padding()

			Text(LocalizedStringKey("auction_label_noItems"))
				.applyTextStyle(style: .body)

			Spacer()
		}
	}

	private var categoriesList: some View {
		ScrollView(.vertical) {
			ForEach(viewModel.categories, id: \.id) { category in
				createCategoryView(for: category)
			}
		}
	}

	private func createCategoryView(for category: CategoryModel) -> AnyView {
		AnyView(VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding()

			ScrollView(.horizontal) {
				ForEach(category.items ?? [], id: \.id) { item in
					ItemView(item: item)
				}
			}
			.defaultScrollAnchor(.leading)
			.frame(height: 370)
		})
	}
}
