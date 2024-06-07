// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemsViewModel: ObservableObject {
	private let dataManager: DataManager?
	@Published var searchText: String = ""
	@Published var filteredItems: [ItemModel] = []

	private var items: [ItemModel] = []

	init(dataManager: DataManager? = nil) {
		self.dataManager = dataManager
		// Fetch items from dataManager or other source
		self.items = fetchItems()
		self.filteredItems = items
	}

	func search() {
		if searchText.isEmpty {
			filteredItems = items
		}
		else {
			// filteredItems = items.filter { $0.contains(searchText)! }
		}
	}

	private func fetchItems() -> [ItemModel] {
		// Fetch or generate items
		[]
	}
}
