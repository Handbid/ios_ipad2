// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService
import SwiftUI

class PaddleInputViewModel: ObservableObject {
	@Published var inputText: String = ""
	@Published var showError: Bool = false
	@Published var isLoading: Bool = false
	@Published var alertMessage: String = ""

	private var repositoryTransaction: PerformTransactionRepository
	private var cancellables = Set<AnyCancellable>()
	private var dataManager = DataManager.shared
	private let auction: AuctionModel?

	init(repositoryPerformTransaction: PerformTransactionRepository) {
		self.repositoryTransaction = repositoryPerformTransaction
		self.auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction)
	}

	func performAction(for item: ItemModel, valueType: ItemValueType, selectedAction: ActionButtonType?) {
		guard let action = selectedAction else {
			showError = true
			alertMessage = "No action selected."
			return
		}

		isLoading = true

		DispatchQueue.main.async {
			switch action {
			case .bidNow:
				self.handleBidNow(for: item, amount: valueType.doubleValue ?? -1)
			case .setMaxBid:
				self.handleSetMaxBid(for: item, amount: valueType.doubleValue ?? -1)
			case .buyNow:
				self.handleBuyNow(for: item, amount: item.buyNowPrice ?? -1)
			case .directPurchase:
				self.handlePurchaseWithQuantity(for: item, quantity: valueType.doubleValue ?? -1)
			case .buyNowPuzzle:
				self.handlePurchase(for: item, amount: item.buyNowPrice ?? -1)
			case .placeOrder:
				self.handlePurchase(for: item, amount: valueType.doubleValue ?? -1)
			case .editPlaceOrder:
				self.handlePurchase(for: item, amount: valueType.doubleValue ?? -1)
			case .donate:
				self.handlePurchase(for: item, amount: valueType.doubleValue ?? -1)
			}
		}
	}

	private func handleBidNow(for item: ItemModel, amount: Double) {
		guard let itemId = item.id else { return }
		print("Bid Now for item \(String(describing: item.id)) with amount \(amount)")
		repositoryTransaction.performTransaction(userID: nil,
		                                         paddleNumber: Int(inputText),
		                                         auctionId: auction?.identity ?? -1,
		                                         itemId: itemId,
		                                         amount: amount,
		                                         maxAmount: nil,
		                                         quantity: nil,
		                                         discountId: nil,
		                                         ignoreCC: false,
		                                         finalBid: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedData)
			.store(in: &cancellables)
	}

	private func handleSetMaxBid(for item: ItemModel, amount: Double) {
		print("Set Max Bid for item \(item.id) with amount \(amount)")
		guard let itemId = item.id else { return }
		repositoryTransaction.performTransaction(userID: nil,
		                                         paddleNumber: Int(inputText),
		                                         auctionId: auction?.identity ?? -1,
		                                         itemId: itemId,
		                                         amount: nil,
		                                         maxAmount: amount,
		                                         quantity: nil,
		                                         discountId: nil,
		                                         ignoreCC: false,
		                                         finalBid: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedData)
			.store(in: &cancellables)
	}

	private func handleBuyNow(for item: ItemModel, amount: Double) {
		print("Buy Now for item \(item.id) with amount \(amount)")
		guard let itemId = item.id else { return }
		repositoryTransaction.performTransaction(userID: nil,
		                                         paddleNumber: Int(inputText),
		                                         auctionId: auction?.identity ?? -1,
		                                         itemId: itemId,
		                                         amount: amount,
		                                         maxAmount: nil,
		                                         quantity: nil,
		                                         discountId: nil,
		                                         ignoreCC: false,
		                                         finalBid: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedData)
			.store(in: &cancellables)
	}

	private func handlePurchase(for item: ItemModel, amount: Double) {
		print("Purchase for item \(item.id) with amount \(amount)")
		guard let itemId = item.id else { return }
		repositoryTransaction.performTransaction(userID: nil,
		                                         paddleNumber: Int(inputText),
		                                         auctionId: auction?.identity ?? -1,
		                                         itemId: itemId,
		                                         amount: item.buyNowPrice,
		                                         maxAmount: nil,
		                                         quantity: nil,
		                                         discountId: nil,
		                                         ignoreCC: false,
		                                         finalBid: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedData)
			.store(in: &cancellables)
	}

	private func handlePurchaseWithQuantity(for item: ItemModel, quantity: Double) {
		print("Purchase quantity for item \(item.id) with quantity \(quantity)")
		guard let itemId = item.id else { return }
		repositoryTransaction.performTransaction(userID: nil,
		                                         paddleNumber: Int(inputText),
		                                         auctionId: auction?.identity ?? -1,
		                                         itemId: itemId,
		                                         amount: Double(quantity) * (item.buyNowPrice ?? -1),
		                                         maxAmount: nil,
		                                         quantity: Int(quantity),
		                                         discountId: nil,
		                                         ignoreCC: false,
		                                         finalBid: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedData)
			.store(in: &cancellables)
	}

	private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
		if case let .failure(error) = completion {
			if let urlError = error as? URLError {
				alertMessage = "Network error: \(urlError.localizedDescription)"
			}
			else if let responseError = error as? ResponseError,
			        let errorData = responseError.data.error,
			        let paddleNumberError = errorData["paddleNumber"]
			{
				alertMessage = paddleNumberError
			}
			else {
				alertMessage = "Unexpected error: \(error.localizedDescription)"
			}
			showError = true
			isLoading = false
		}
		else {
			isLoading = false
		}
	}

	private func handleReceivedData(data _: BidModel) {
		isLoading = false
	}
}

struct ResponseError: Error, Decodable {
	let data: ErrorData

	struct ErrorData: Decodable {
		let error: [String: String]?
	}
}
