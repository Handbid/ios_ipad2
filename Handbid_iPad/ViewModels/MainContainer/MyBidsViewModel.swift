// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

enum BidSectionType: String, CaseIterable, Identifiable {
	var id: String { rawValue }
	case winning = "Winning"
	case losing = "Losing"
	case purchased = "Purchased"
}

struct BidSection: Identifiable {
	let id = UUID()
	let type: BidSectionType
	let title: String
	let items: [BidModel]
	let total: String
}

class MyBidsViewModel: ObservableObject, ViewModelTopBarProtocol {
	@Published var title = "My Bids"
	@Published var paddleNumber: String = ""
	@Published var error: String = ""
	@Published var isLoading: Bool = false
	@Published var isLoadingBids: Bool = false
	@Published var subView: MyBidsView.SubView = .findPaddle
	@Published var showError: Bool = false
	@Published var selectedBidder: BidderModel?

	@Published var isWinningExpanded: Bool = false
	@Published var isLosingExpanded: Bool = false
	@Published var isPurchasedExpanded: Bool = false
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var sections: [BidSection] {
		[
			BidSection(type: .winning, title: "Winning", items: winningItems, total: winningTotal),
			BidSection(type: .losing, title: "Losing", items: losingItems, total: losingTotal),
			BidSection(type: .purchased, title: "Purchased", items: purchasedItems, total: purchasedTotal),
		]
	}

	var winningTotal: String {
		totalAmount(for: winningItems)
	}

	var losingTotal: String {
		totalAmount(for: losingItems)
	}

	var purchasedTotal: String {
		totalAmount(for: purchasedItems)
	}

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

	func deleteCard(withId _: Int) {
		// selectedBidder?.creditCards.removeAll { $0.id == id }
	}

	func addNewCard() {
		// Implement adding a new card
		// let newCard = CreditCardModel(id: Int.random(in: 100 ... 999), nameOnCard: "New Card")
		// selectedBidder?.creditCards.append(newCard)
	}

	func colorForSection(title: String) -> Color {
		switch title {
		case "Winning":
			.green
		case "Losing":
			.red
		default:
			.yellow
		}
	}

	private func totalAmount(for items: [BidModel]) -> String {
		let total = items.reduce(0) { $0 + ($1.currentAmount ?? 0) }
		return String(total.formatted(.currency(code: "\(selectedBidder?.currency ?? "")")))
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

		dataManager.onDataChanged
			.sink { [weak self] in
				self?.updateAuctionId()
			}
			.store(in: &cancellables)

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
		$paddleNumber
			.sink { [weak self] _ in
				self?.clearError()
			}
			.store(in: &cancellables)
	}

	func clearError() {
		error = ""
	}

	func validatePaddleNumber() -> Bool {
		guard !paddleNumber.isEmpty else {
			error = String(localized: "paddle_number_empty_error")
			return false
		}

		guard let number = Int(paddleNumber), number > 0 else {
			error = String(localized: "paddle_number_invalid_error")
			return false
		}

		error = ""
		return true
	}

	func requestFindingBidder() {
		isLoading = true

		myBidsRepository.findBidder(paddleNumber: paddleNumber, auctionId: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] completion in
				self?.isLoading = false
				if case let .failure(error) = completion {
					self?.error = error.localizedDescription
				}
			}, receiveValue: { [weak self] response in
				if response.usersGuid != nil {
					self?.selectedBidder = response
					self?.subView = .detailsPurchaseBidder
				}
				else {
					self?.error = String(localized: "global_error_bidderNotFound")
				}
			})
			.store(in: &cancellables)
	}

	func requestFetchBids() {
		isLoadingBids = true
		myBidsRepository.fetchBidderBids(paddleNumber: paddleNumber, auctionId: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] completion in
				self?.isLoadingBids = false
				if case let .failure(error) = completion {
					self?.error = error.localizedDescription
				}
			}, receiveValue: { [weak self] response in
				if !response.isEmpty {
					self?.bidsBidder = response
				}
				else {
					self?.error = "Bids not found"
				}
			})
			.store(in: &cancellables)
	}
}
