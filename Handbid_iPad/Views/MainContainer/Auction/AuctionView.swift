// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionView: ContentView {
	@ObservedObject var viewModel: AuctionViewModel
	@State var categories: [CategoryModel] = []
	@State var isLoading = true

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		LoadingOverlay(isLoading: $isLoading) {
			VStack {
				if categories.isEmpty, !isLoading {
					noItemsView
				}
				else {
					categoriesList
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.containerBackground)
		.edgesIgnoringSafeArea(.all)
		.onReceive(viewModel.$filteredCategories) { categories in
			self.categories = categories
		}
		.onReceive(viewModel.$isLoading) { loading in
			isLoading = loading
		}
		.onAppear {
			viewModel.refreshData()
		}
		.accessibilityIdentifier("AuctionView")
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
			LazyVStack {
				ForEach(categories, id: \.id) { category in
					createCategoryView(for: category)
				}
			}
		}
		.scrollIndicators(.never)
	}

	private func createCategoryView(for category: CategoryModel) -> AnyView {
		AnyView(VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding(.bottom, -10)

			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(category.items ?? [], id: \.id) { item in
						ItemView(item: item, currencyCode: viewModel.currencyCode)
					}
				}
			}
			.scrollIndicators(.never)
			.defaultScrollAnchor(.leading)
		})
	}
}
