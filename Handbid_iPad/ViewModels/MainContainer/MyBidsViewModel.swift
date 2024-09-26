// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

class MyBidsViewModel: ObservableObject, ViewModelTopBarProtocol {
	@Published var title = "My Bids"
	@Published var paddleNumber: String
	@Published var error: String
	@Published var isLoading: Bool = false
	@Published var isLoadingBids: Bool = false
	@Published var subView: MyBidsView.SubView
	@Published var showError: Bool = false
	@Published var selectedBidder: BidderModel?
	@Published var isWinningExpanded: Bool = false
	@Published var isLosingExpanded: Bool = false
	@Published var isPurchasedExpanded: Bool = false

	var winningTotal: String {
		let totalAmount = winningItems.reduce(0) { $0 + ($1.amount ?? 0) }
		return "$\(totalAmount)"
	}

	var losingTotal: String {
		let totalAmount = losingItems.reduce(0) { $0 + ($1.amount ?? 0) }
		return "$\(totalAmount)"
	}

	var purchasedTotal: String {
		let totalAmount = purchasedItems.reduce(0) { $0 + ($1.amount ?? 0) }
		return "$\(totalAmount)"
	}

	@Published var creditCards: [CreditCardModel] = [
		CreditCardModel(id: 12, nameOnCard: "test"),
		CreditCardModel(id: 23, nameOnCard: "abc"),
	]

	@Published var bidsBidder: [BidModel]? {
		didSet {
			updateBidItems()
		}
	}

	@Published var winningItems: [BidModel] = []
	@Published var losingItems: [BidModel] = []
	@Published var purchasedItems: [BidModel] = []

	private func updateBidItems() {
		let bids = bidsBidder ?? []
		winningItems = bids.filter { $0.statusBidType == .winning }
		losingItems = bids.filter { $0.statusBidType == .losing }
		purchasedItems = bids.filter { $0.statusBidType == .purchase }
	}

	func deleteCard(at offsets: IndexSet) {
		creditCards.remove(atOffsets: offsets)
	}

	func addNewCard() {
		creditCards.append(CreditCardModel(id: 45, nameOnCard: "etdf"))
	}

	var auctionId: Int
	var auctionGuid: String
	var actions: [TopBarAction] { [] }

	private let dataManager = DataManager.shared
	private var cancellables = Set<AnyCancellable>()
	private let myBidsRepository: MyBidsRepository

	init(myBidsRepository: MyBidsRepository) {
		self.myBidsRepository = myBidsRepository
		self.auctionId = -1
		self.auctionGuid = ""
		self.paddleNumber = ""
		self.error = ""
		self.subView = .findPaddle

		dataManager.onDataChanged.sink {
			self.updateAuctionId()
		}.store(in: &cancellables)

		updateAuctionId()
		setUpClearingError()
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	private func updateAuctionId() {
		guard let auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction),
		      let auctionId = auction.identity,
		      let auctionGuid = auction.auctionGuid
		else { return }

		self.auctionId = auctionId
		self.auctionGuid = auctionGuid
	}

	private func setUpClearingError() {
		let fields = [$paddleNumber]

		for field in fields {
			field.sink { _ in
				self.clearError()
			}.store(in: &cancellables)
		}
	}

	func clearError() {
		error = ""
	}

	func validatePaddleNumber() -> Bool {
		guard !paddleNumber.isEmpty else {
			error = String(localized: "paddle_number_empty_error")
			return false
		}

		guard let number = Int(paddleNumber) else {
			error = String(localized: "paddle_number_invalid_error")
			return false
		}

		guard number > 0 else {
			error = String(localized: "paddle_number_positive_error")
			return false
		}

		error = ""
		return true
	}

	func requestFindingBidder() {
		isLoading = true

		myBidsRepository.findBidder(paddleNumber: paddleNumber, auctionId: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: {
				self.isLoading = false
				switch $0 {
				case .finished:
					print("Finished finding user")
				case let .failure(e):
					print("Error finding user: \(e)")
					self.error = e.localizedDescription
				}
			}, receiveValue: { response in
				print(response)
				self.selectedBidder = nil
				if response.usersGuid != nil {
					self.selectedBidder = response
					self.subView = .detailsPurchaseBidder
				}
				else {
					self.error = String(localized: "global_error_bidderNotFound")
				}
			})
			.store(in: &cancellables)
	}

	func requestFetchBids() {
		isLoadingBids = true
		myBidsRepository.fetchBidderBids(paddleNumber: paddleNumber, auctionId: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: {
				switch $0 {
				case .finished:
					print("Finished fetching bids")
				case let .failure(e):
					print("Error fetching bids: \(e)")
					self.error = e.localizedDescription
				}
			}, receiveValue: { response in
				print(response)
				self.bidsBidder = nil
				if response.count > 0 {
					self.bidsBidder = response
				}
				else {
					self.error = "Bids not found"
				}
				self.isLoadingBids = false
			})
			.store(in: &cancellables)
	}
}
