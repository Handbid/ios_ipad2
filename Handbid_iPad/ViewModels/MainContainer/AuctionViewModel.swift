// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var repository: AuctionRepository
	private var auctionId: Int = 0
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title: String
	@Published var auctionStatus: AuctionStateStatuses
	@Published var categories: [CategoryModel]
	@Published var currencyCode: String
	@Published var isLoading: Bool = true

	private var cancellables = Set<AnyCancellable>()
	private var dataManager = DataManager.shared

	init(dataService: DataServiceWrapper, repository: AuctionRepository) {
		self.title = ""
		self.auctionStatus = .open
		self.categories = []
		self.currencyCode = "USD"

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
			                                            status: auctionStatus.rawValue.capitalized,
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
		isLoading = true
		repository.getAuctionDetails(id: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: {
				self.isLoading = false
				switch $0 {
				case .finished:
					print("Finished fetching auction items")
				case let .failure(e):
					print("Error fetching auction items: \(e)")
				}
			}, receiveValue: { auction in
				self.isLoading = false
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
		guard let id = auction.identity,
		      let name = auction.name,
		      let status = auction.status,
		      let currencyCode = auction.currencyCode,
		      let categories = auction.categories
		else { return }
		auctionId = id
		title = name
		auctionStatus = status
		self.currencyCode = currencyCode
		self.categories = categories.filter { $0.items?.isEmpty == false }
	}
}
