// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SearchItemsView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject var viewModel: SearchItemsViewModel
	@StateObject var deviceContext = DeviceContext()
	@FocusState private var focusedField: Field?
	var inspection = Inspection<Self>()

	private let cellWidth: CGFloat = 368
	private let cellHeight: CGFloat = 444

	var body: some View {
		GeometryReader { geometry in
			let columns = createGridItems(width: geometry.size.width, targetWidth: cellWidth)
			VStack(spacing: 0) {
				topBarContent(for: .searchItems)
					.accessibility(identifier: "topBar")
					.frame(height: 150)

				VStack(spacing: 0) {
					HStack {
						FormField(
							fieldType: .searchBarItems,
							labelKey: LocalizedStringKey("search_item_label"),
							hintKey: LocalizedStringKey("search_item_label"),
							fieldValue: $viewModel.searchText,
							focusedField: _focusedField
						)

						Button(action: {
							coordinator.pop()
						}) {
							Image("closeIcon")
								.scaledToFit()
								.foregroundColor(.gray)
								.frame(width: 60, height: 60)
						}
					}
					.padding([.leading, .trailing], 30)

					HStack {
						Text("\(viewModel.filteredItems.count) results for")
							.padding(.top, 8)
							.foregroundColor(.black)
						Text("\"\(viewModel.searchText)\"")
							.padding(.top, 8)
							.padding(.leading, 0)
							.foregroundColor(.black)
							.fontWeight(.bold)
						Spacer()
					}
					.padding([.leading, .trailing], 30)

					if !viewModel.searchHistory.isEmpty {
						VStack(alignment: .leading) {
							Text("Search History")
								.font(.subheadline)
								.foregroundColor(.gray)
								.padding([.leading, .top], 10)
								.fontWeight(.bold)
							ScrollView {
								VStack(alignment: .leading, spacing: 0) {
									ForEach(viewModel.searchHistory.indices, id: \.self) { index in
										VStack(alignment: .leading, spacing: 0) {
											Text(viewModel.searchHistory[index])
												.font(.body)
												.foregroundColor(.black)
												.onTapGesture {
													viewModel.searchText = viewModel.searchHistory[index]
													viewModel.search()
												}
												.padding(.leading, 10)
												.padding(.vertical, 10)
											if index < viewModel.searchHistory.count - 1 {
												Divider()
													.padding(.horizontal, 10)
											}
										}
									}
								}
								.padding([.leading, .trailing], 10)
							}
							.frame(maxHeight: 100)
						}
						.background(Color.clear)
						.cornerRadius(10)
						.padding([.leading, .trailing], 30)
						.frame(maxWidth: .infinity, alignment: .leading)
					}

					ScrollView {
						LazyVGrid(columns: columns, spacing: 20) {
							ForEach(viewModel.filteredItems, id: \.id) { item in
								ItemView(item: item, currencyCode: "USD", viewWidth: 337, viewHeight: 400)
									.frame(width: cellWidth, height: cellHeight)
									.onTapGesture {
										viewModel.addToSearchHistory(viewModel.searchText)
									}
									.accessibilityIdentifier("ItemsCollectionCellView")
							}
						}
						.padding()
					}
					.accessibilityIdentifier("ItemsScrollView")
					.frame(maxHeight: calculateScrollViewHeight(geometry: geometry))
				}
			}
		}
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
		.onTapGesture {
			hideKeyboard()
		}
		.navigationBarBackButtonHidden()
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private func topBarContent(for viewType: MainContainerTypeSubPagesView) -> some View {
		switch viewType {
		case .searchItems:
			AnyView(EmptyView())
		}
	}

	private func calculateScrollViewHeight(geometry: GeometryProxy) -> CGFloat {
		let totalHeight = geometry.size.height
		let topBarHeight: CGFloat = 150
		let resultsHeight: CGFloat = 50
		let historyHeight: CGFloat = !viewModel.searchHistory.isEmpty ? 100 : 0
		return max(0, totalHeight - topBarHeight - resultsHeight - historyHeight)
	}
}
