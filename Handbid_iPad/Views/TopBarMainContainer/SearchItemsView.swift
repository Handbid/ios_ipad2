// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SearchItemsView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject var viewModel: SearchItemsViewModel
	@StateObject var deviceContext = DeviceContext()
	@FocusState private var focusedField: Field?

	private let cellWidth: CGFloat = 307
	private let cellHeight: CGFloat = 370

	var body: some View {
		GeometryReader { geometry in
			let columns = createGridItems(width: geometry.size.width, targetWidth: cellWidth)
			VStack(spacing: 0) {
				topBarContent(for: .searchItems)
					.accessibility(identifier: "topBar")
					.frame(height: 150)
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(viewModel.filteredItems, id: \.id) { _ in
						//                        AuctionCollectionCellView<MainContainerPage>(auction: auction)
						//                            .frame(width: cellWidth, height: cellHeight)
						//                            .accessibilityIdentifier("AuctionCollectionCellView_\(auction.id)")
					}
				}
			}
		}
		.navigationBarBackButtonHidden()
	}

	private func topBarContent(for viewType: MainContainerTypeSubPagesView) -> some View {
		switch viewType {
		case .searchItems:
			AnyView(
				VStack(spacing: 5) {
					HStack {
						FormField(
							fieldType: .searchBar,
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

					Text("\(viewModel.filteredItems.count) results for \"\(viewModel.searchText)\"")
						.padding(.top, 8)
						.foregroundColor(.gray)
				}
			)
		}
	}
}
