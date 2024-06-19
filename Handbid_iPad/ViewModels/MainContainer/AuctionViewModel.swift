// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class AuctionViewModel: ObservableObject, ViewModelTopBarProtocol {
	private var repository: AuctionRepository
	private var auctionId: Int = 0
	var eventPublisher = PassthroughSubject<MainContainerChangeViewEvents, Never>()
	@ObservedObject var dataService: DataServiceWrapper
	private var auction: AuctionModel?
	@Published var categories: [CategoryModel]
	@Published var filteredCategories: [CategoryModel]
	@Published var currencyCode: String
	@Published var isLoading: Bool = true

	private var cancellables = Set<AnyCancellable>()
	private var dataManager = DataManager.shared

	init(dataService: DataServiceWrapper, repository: AuctionRepository) {
		self.categories = []
		self.filteredCategories = []
		self.currencyCode = "USD"

		self.dataService = dataService
		self.repository = repository
		dataManager.onDataChanged.sink {
			self.updateAuction()
		}.store(in: &cancellables)

		$categories.sink { categories in
			self.filteredCategories = categories.filter(\.isVisible)
		}.store(in: &cancellables)

		updateAuction()
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .custom,
			customView: AnyView(AuctionTopBarCenterView(title: auction?.name ?? "",
			                                            status: auction?.status?.rawValue.capitalized
			                                            	?? "",
			                                            date: TimeInterval(auction?.endTime ?? 0),
			                                            countItems: auction?.totalItems ?? -1))
		)
	}

	var actions: [TopBarAction] {
		[
			TopBarAction(icon: "loupeIcon", title: nil, action: searchData),
			TopBarAction(icon: "filtersIcon", title: nil, action: filterData),
			TopBarAction(icon: "refreshIcon", title: nil, action: refreshData),
		]
	}

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

	func searchData() {
		eventPublisher.send(MainContainerChangeViewEvents.searchItems)
	}

	func filterData() {
		eventPublisher.send(MainContainerChangeViewEvents.filterItems)
	}

	func closeOverlay() {
		eventPublisher.send(MainContainerChangeViewEvents.closeOverlay)
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
		      let categories = auction.categories
		else { return }
		auctionId = id
		self.auction = auction
		currencyCode = auction.currencyCode ?? "USD"
		self.categories = categories.filter { $0.items?.isEmpty == false }
	}
}
