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
				ScrollView {
					LazyVGrid(columns: columns, spacing: 20) {
						ForEach(viewModel.filteredItems, id: \.id) { item in
							ItemView(item: item, currencyCode: viewModel.currencyCode)
								.frame(width: cellWidth, height: cellHeight)
								.accessibilityIdentifier("ItemsCollectionCellView")
						}
					}
					.padding()
				}
				.accessibilityIdentifier("ItemsScrollView")
				Spacer()
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
		.keyboardResponsive()
	}

	private func topBarContent(for viewType: MainContainerTypeSubPagesView) -> some View {
		switch viewType {
		case .searchItems:
			AnyView(
				VStack(spacing: 5) {
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
				}
			)
		}
	}
}
