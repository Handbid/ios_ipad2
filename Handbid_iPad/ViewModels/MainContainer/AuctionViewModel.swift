// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper

	@Published var title = "Auction Details"
	@Published var auctionDate = "Next Auction: Tomorrow"

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "loupeIcon", action: searchData),
			TopBarAction(icon: "filtersIcon", action: filterData),
			TopBarAction(icon: "refreshIcon", action: refreshData),
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