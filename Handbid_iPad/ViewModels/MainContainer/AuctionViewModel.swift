// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper

	@Published var title = "Auction Details"
	@Published var auctionDate = "Next Auction: Tomorrow"

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
	}

	var centerViewData: TopBarCenterViewData = .init(
        type: .custom,
		title: "Auction Title"
	)

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "magnifyingglass", action: searchData),
			TopBarAction(icon: "line.horizontal.3.decrease.circle", action: filterData),
			TopBarAction(icon: "arrow.clockwise", action: refreshData),
		]
	}

	func searchData() {}
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
