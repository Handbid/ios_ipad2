// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemsViewModel: ObservableObject {
	private var dataManager = DataManager.shared
	@Published var searchText: String = ""
	@Published var filteredItems: [ItemModel] = []
	@Published var currencyCode: String

	private var auction: AuctionModel?
	private var items: [ItemModel] = []

	private var cancellables = Set<AnyCancellable>()

	init() {
		self.auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction)
		self.currencyCode = auction?.currencyCode ?? "USD"
		self.filteredItems = items

		self.items = auction?.categories?.first?.items ?? .init()

		$searchText
			.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] _ in
				self?.search()
			}
			.store(in: &cancellables)
	}

	func search() {
		if searchText.isEmpty {
			filteredItems = items
		}
		else {
			let lowercasedSearchText = searchText.lowercased()
			filteredItems = items.filter { item in
				if let name = item.name {
					return name.lowercased().contains(lowercasedSearchText)
				}
				return false
			}
		}
	}

	private func fetchItems() -> [ItemModel] {
		filteredItems
	}
}
