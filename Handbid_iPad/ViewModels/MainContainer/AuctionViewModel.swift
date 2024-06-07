// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var repository: AuctionRepository
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Auction Details"
	@Published var auctionStatus = "Open"
	@Published var categories: [CategoryModel] = [
		CategoryModel(id: 1, name: "Test", auctionId: 1,
		              items: [
		              	ItemModel(id: 1, name: "Test Item", categoryName: "Test",
		              	          isDirectPurchaseItem: true, isTicket: false, isPuzzle: false,
		              	          isAppeal: false, currentPrice: 20.0, itemCode: "123"),
		              ]),
	]

	private var cancellables = Set<AnyCancellable>()

	init(dataService: DataServiceWrapper, repository: AuctionRepository) {
		self.dataService = dataService
		self.repository = repository
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .custom,
			customView: AnyView(AuctionTopBarCenterView(title: title,
			                                            status: auctionStatus,
			                                            date: 1_678_608_000,
			                                            countItems: 20))
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "loupeIcon", title: nil, action: searchData),
			TopBarAction(icon: "filtersIcon", title: nil, action: filterData),
			TopBarAction(icon: "refreshIcon", title: nil, action: refreshData),
		]
	}

	func searchData() {}
	func refreshData() {
		repository.getAuctionDetails(id: 1)
			.sink(receiveCompletion: {
				switch $0 {
				case .finished:
					print("Finished fetching auction items")
				case let .failure(e):
					print("Error fetching auction items: \(e)")
				}
			}, receiveValue: { auction in
				self.title = auction.name ?? "Details"
				self.auctionStatus = auction.status ?? "unknown"
				self.categories = auction.categories?.filter { $0.items?.isEmpty == false } ?? []
			})
			.store(in: &cancellables)
	}

	func filterData() {
		dataService.fetchData { result in
			DispatchQueue.main.async {
				switch result {
				case let .success(data):
					print("Data fetched successfully: \(data)")
				case let .failure(error):
					print("Error fetching data: \(error)")
				}
			}
		}
	}
}
