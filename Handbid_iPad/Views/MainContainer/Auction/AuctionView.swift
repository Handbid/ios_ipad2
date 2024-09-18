// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionView: View {
	@ObservedObject var viewModel: AuctionViewModel
	@State var isLoading = true
	var inspection = Inspection<Self>()
	@State private var categories: [CategoryModel] = []
	@State private var selectedItem: ItemModel? = nil
	@State private var showDetailView: Bool = false
	@State private var loadImages: Bool = false
	@StateObject private var detailState = ItemDetailState()

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		LoadingOverlay(isLoading: $isLoading) {
			ZStack {
				VStack {
					if categories.isEmpty, !isLoading {
						noItemsView
					}
					else {
						categoriesList
					}
				}
			}

			if let selectedItem, showDetailView {
				overlayView
				itemDetailView(for: selectedItem)
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
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
		.accessibilityIdentifier("AuctionView")
		.onAppear {
			viewModel.refreshData()
		}
	}

	private var noItemsView: some View {
		VStack {
			Spacer()
			ZStack {
				Circle()
					.stroke(Color.accentViolet.opacity(0.3), lineWidth: 1.0)
					.frame(width: 100, height: 100)
				Image("noItemsIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 50, height: 50)
			}
			.padding()
			Text(LocalizedStringKey("auction_label_noItems"))
				.applyTextStyle(style: .body)
			Spacer()
		}
		.accessibilityIdentifier("noItemsView")
	}

	private var categoriesList: some View {
		ScrollView(.vertical) {
			LazyVStack {
				ForEach(categories, id: \.id) { category in
					CategoryView(category: category) { item in
						withAnimation {
							selectedItem = item
							showDetailView = true
							detailState.reset()
						}
					}
				}
			}
		}
		.accessibilityIdentifier("categoriesList")
	}

	private var overlayView: some View {
		Color.black.opacity(0.5)
			.onTapGesture {
				withAnimation {
					showDetailView = false
					selectedItem = nil
					loadImages = false
				}
			}
			.accessibilityIdentifier("overlay")
	}

	private func itemDetailView(for item: ItemModel) -> some View {
		ItemDetailView(
			isVisible: $showDetailView,
			loadImages: $loadImages,
			item: item,
			detailState: detailState
		)
		.id(item.id)
		.padding(10)
		.background(Color.accentViolet.opacity(0.5))
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				loadImages = true
			}
		}
		.onDisappear {
			selectedItem = nil
			loadImages = false
		}
		.accessibilityIdentifier("itemDetailView")
	}
}
