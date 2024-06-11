// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionView: View {
	@ObservedObject var viewModel: AuctionViewModel
	@State var categories: [CategoryModel] = []
	@State private var selectedItem: ItemModel? = nil
	@State private var showDetailView: Bool = false

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			VStack {
				if categories.isEmpty {
					noItemsView
				}
				else {
					categoriesList
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color(.systemBackground))
			.edgesIgnoringSafeArea(.all)
			.onReceive(viewModel.$categories) { categories in
				self.categories = categories
			}
			.onAppear {
				viewModel.refreshData()
			}

			if let selectedItem, showDetailView {
				Color.black.opacity(0.5)
					.ignoresSafeArea()
					.onTapGesture {
						withAnimation {
							showDetailView = false
						}
					}

				ItemDetailView(item: selectedItem, isVisible: $showDetailView)
					.transition(.move(edge: .bottom))
					.animation(.easeInOut(duration: 0.4), value: showDetailView)
			}
		}
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
	}

	private func createCategoryView(for category: CategoryModel) -> AnyView {
		AnyView(VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding()

			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(category.items ?? [], id: \.id) { item in
						ItemView(item: item)
							.onTapGesture {
								withAnimation {
									selectedItem = item
									showDetailView = true
								}
							}
					}
					.padding()
				}
			}
			.defaultScrollAnchor(.leading)
			.frame(height: 370)
		})
	}
}

struct ItemDetailView: View {
	var item: ItemModel
	@Binding var isVisible: Bool
	@State private var offset: CGFloat = 0

	var body: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()

				VStack {
					HStack {
						Spacer()
						Button(action: {
							withAnimation {
								offset = geometry.size.height
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
									isVisible = false
									offset = 0
								}
							}
						}) {
							Image(systemName: "xmark")
								.padding()
								.background(Color.gray.opacity(0.7))
								.clipShape(Circle())
						}
						.padding()
					}

					Text("Detail View for \(item.name ?? "Item")")
						.font(.largeTitle)
						.padding()


					Spacer()
				}
				.frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
				.background(Color.white)
				.cornerRadius(20)
				.shadow(radius: 20)
				.offset(y: offset)
				.gesture(
					DragGesture()
						.onChanged { gesture in
							if gesture.translation.height > 0 {
								offset = gesture.translation.height
							}
						}
						.onEnded { gesture in
							if gesture.translation.height > 100 {
								withAnimation {
									offset = geometry.size.height
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
										isVisible = false
										offset = 0
									}
								}
							}
							else {
								withAnimation {
									offset = 0
								}
							}
						}
				)
				.animation(.easeInOut(duration: 0.4), value: offset)
				.padding(10)
			}
			.edgesIgnoringSafeArea(.all)
		}
	}
}
