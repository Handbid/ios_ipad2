// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemsViewModel: ObservableObject {
	private let dataManager: DataManager?
	@Published var searchText: String = ""
	@Published var filteredItems: [ItemModel] = []
	@Published var currencyCode: String

	private var items: [ItemModel] = [ItemModel(id: 1, name: "Test Item", categoryName: "Test",
	                                            isDirectPurchaseItem: true, isTicket: false, isPuzzle: false,
	                                            isAppeal: false, currentPrice: 20.0, itemCode: "123")]

	init(dataManager: DataManager? = nil) {
		self.dataManager = dataManager
		self.currencyCode = "USD"

		// Fetch items from dataManager or other source
		// self.items = fetchItems()
		self.filteredItems = items
	}

	func search() {
		// if searchText.isEmpty {
		filteredItems = items
//		}
//		else {
		// filteredItems = items.filter { $0.contains(searchText)! }
		// }
	}

	private func fetchItems() -> [ItemModel] {
		// Fetch or generate items
		filteredItems
		// []
	}
}
