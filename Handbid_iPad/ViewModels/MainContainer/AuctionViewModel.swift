// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var repository: AuctionRepository
	private var auctionId: Int = 0
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Auction Details"
	@Published var auctionStatus = "Open"
	@Published var categories: [CategoryModel] = []
	@Published var currencyCode: String = "USD"

	private var cancellables = Set<AnyCancellable>()
	private var dataManager = DataManager.shared

	init(dataService: DataServiceWrapper, repository: AuctionRepository) {
		self.dataService = dataService
		self.repository = repository
		dataManager.onDataChanged.sink {
			self.updateAuction()
		}.store(in: &cancellables)

		updateAuction()
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
		repository.getAuctionDetails(id: auctionId)
			.sink(receiveCompletion: {
				switch $0 {
				case .finished:
					print("Finished fetching auction items")
				case let .failure(e):
					print("Error fetching auction items: \(e)")
				}
			}, receiveValue: { auction in
				do {
					try self.dataManager.update(auction, withNestedUpdates: true, in: .auction)
				}
				catch {
					print(error)
				}
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

	private func updateAuction() {
		do {
			guard let auction = try dataManager.fetchSingle(of: AuctionModel.self, from: .auction)
			else { return }
			handleAuctionUpdate(auction: auction)
		}
		catch {
			print(error)
		}
	}

	private func handleAuctionUpdate(auction: AuctionModel) {
		auctionId = auction.identity ?? 0
		title = auction.name ?? "Details"
		auctionStatus = auction.status?.capitalized ?? "Unknown"
		currencyCode = auction.currencyCode ?? "USD"
		categories = auction.categories?.filter { $0.items?.isEmpty == false } ?? []
	}
}
