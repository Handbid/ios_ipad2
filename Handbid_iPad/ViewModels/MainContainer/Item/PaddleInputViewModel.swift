// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

class PaddleInputViewModel: ObservableObject {
	@Published var inputText: String = ""
	@Published var showError: Bool = false
	@Published var isLoading: Bool = false

	private var repositoryTransaction: PerformTransactionRepository
	private var cancellables = Set<AnyCancellable>()

	init(repositoryPerformTransaction: PerformTransactionRepository) {
		self.repositoryTransaction = repositoryPerformTransaction
	}

	func performAction(for item: ItemModel, valueType: ItemValueType, selectedAction: ActionButtonType?) {
		guard let action = selectedAction else {
			showError = true
			return
		}

		isLoading = true

		DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
			DispatchQueue.main.async {
				self.isLoading = false

				switch action {
				case .bidNow:
					self.handleBidNow(for: item, amount: valueType.doubleValue ?? 0)
				case .setMaxBid:
					self.handleSetMaxBid(for: item, amount: valueType.doubleValue ?? 0)
				case .buyNow:
					self.handleBuyNow(for: item, amount: item.buyNowPrice ?? 0)
				case .directPurchase:
					self.handlePurchase(for: item, amount: valueType.doubleValue ?? 0)
				case .buyNowPuzzle:
					self.handlePurchase(for: item, amount: item.buyNowPrice ?? 0)
				case .placeOrder:
					self.handlePurchase(for: item, amount: valueType.doubleValue ?? 0)
				case .editPlaceOrder:
					self.handlePurchase(for: item, amount: valueType.doubleValue ?? 0)
				case .donate:
					self.handlePurchase(for: item, amount: valueType.doubleValue ?? 0)
				}
			}
		}
	}

	private func handleBidNow(for item: ItemModel, amount: Double) {
		print("Bid Now for item \(item.id) with amount \(amount)")
	}

	private func handleSetMaxBid(for item: ItemModel, amount: Double) {
		print("Set Max Bid for item \(item.id) with amount \(amount)")
	}

	private func handleBuyNow(for item: ItemModel, amount: Double) {
		print("Buy Now for item \(item.id) with amount \(amount)")
	}

	private func handlePurchase(for item: ItemModel, amount: Double) {
		print("Purchase for item \(item.id) with amount \(amount)")
	}
}
