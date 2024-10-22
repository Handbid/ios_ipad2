// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

class DashboardViewModel: ObservableObject {
	private let dashboardRepository: DashboardRepository
	private let dataManager: DataManager

	private var cancelables: Set<AnyCancellable>

	private var auctionGuid: String
	@Published var dashboardModel: DashboardModel? =
		DashboardModel(
			overallGoal: "$1000000000",
			overallRaised: "$500",
			overallRatio: 0.5,
			biddersRegistered: 15,
			biddersActive: 5,
			donors: 2,
			local: 1,
			guestsRegistered: 5,
			guestsCheckedIn: 1,
			performanceFmv: "$300",
			performanceRaised: "$500",
			performanceRatio: 5 / 3,
			itemsSilent: 15,
			itemsLive: 5,
			itemsPurchase: 12,
			itemsTicket: 10,
			itemsDonation: 7,
			revenueSilent: "$12,000",
			revenueLive: "$5,000",
			revenuePurchase: "$24,500",
			revenueTicket: "$2,500",
			revenueDonation: "$2,300",
			revenueTotal: "$46,300",
			itemsNoBids: 6,
			bidderNoBids: 2,
			bidsPerBidders: 5.67
		)
	@Published var error: String
	@Published var showError: Bool

	init(dashboardRepository: DashboardRepository) {
		self.dashboardRepository = dashboardRepository
		self.dataManager = DataManager.shared
		self.dashboardModel = nil
		self.cancelables = []
		self.auctionGuid = ""
		self.error = ""
		self.showError = false

		dataManager.onDataChanged.sink {
			self.updateGuid()
		}
		.store(in: &cancelables)

		updateGuid()
		!auctionGuid.isEmpty ? getDashboardData() : nil
	}

	private func updateGuid() {
		guard let auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction),
		      let guid = auction.auctionGuid
		else { return }

		auctionGuid = guid
	}

	func getDashboardData() {
		dashboardRepository.fetchDashboard(auctionGuid: auctionGuid)
			.sink(receiveCompletion: { completion in
				switch completion {
				case let .failure(error):
					self.error = error.localizedDescription
					self.showError = true
				case .finished:
					break
				}
			}, receiveValue: { dashboard in
				self.dashboardModel = dashboard
			})
			.store(in: &cancelables)
	}
}
