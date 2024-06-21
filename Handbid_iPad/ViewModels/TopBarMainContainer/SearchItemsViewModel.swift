// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class SearchItemsViewModel: ObservableObject {
	private var dataManager = DataManager.shared
	private let repository: SearchItemsRepository
	@Published var searchText: String = ""
	@Published var filteredItems: [ItemModel] = []
	@Published var searchHistory: [String] = []

	private var items: [ItemModel] = []
	private var cancellables = Set<AnyCancellable>()

	init(repository: SearchItemsRepository) {
		self.repository = repository

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
			fetchItemsFromRepository()
		}
	}

	private func fetchItemsFromRepository() {
		repository.getSearchItems(name: searchText)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case let .failure(error):
					print("Error fetching items: \(error)")
					self.filteredItems = []
				case .finished:
					break
				}
			}, receiveValue: { [weak self] fetchedItems in
				self?.filteredItems = fetchedItems
			})
			.store(in: &cancellables)
	}

	private func fetchItems() -> [ItemModel] {
		filteredItems
	}

	func addToSearchHistory(_ text: String) {
		if !searchHistory.contains(text) {
			searchHistory.insert(text, at: 0)
			if searchHistory.count > 4 {
				searchHistory.removeLast()
			}
		}
		else {
			if let index = searchHistory.firstIndex(of: text) {
				searchHistory.remove(at: index)
				searchHistory.insert(text, at: 0)
			}
		}
	}
}
