// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	var eventPublisher = PassthroughSubject<MainContainerChangeViewEvents, Never>()
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

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
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

	func searchData() {
		eventPublisher.send(MainContainerChangeViewEvents.search)
	}

	func refreshData() {}
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
