// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SearchItemsView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject var searchItemsViewModel: SearchItemsViewModel
	@StateObject var deviceContext = DeviceContext()
	@FocusState private var focusedField: Field?

	var body: some View {
		VStack(spacing: 0) {
			topBarContent(for: .searchItems)
				.accessibility(identifier: "topBar")
				.frame(height: 150)
			GeometryReader { _ in
				ScrollView {
					LazyVStack {
						//                        ForEach(searchItemsViewModel.filteredItems, id: \.self) { item in
						//                            Text(item.name) // replace with your custom cell view
						//                        }
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
							fieldValue: $searchItemsViewModel.searchText,
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

					Text("\(searchItemsViewModel.filteredItems.count) results for \"\(searchItemsViewModel.searchText)\"")
						.padding(.top, 8)
						.foregroundColor(.gray)
				}
			)
		}
	}
}
