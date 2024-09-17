// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ItemDetailViewModel: ObservableObject {
	let repositoryPerformTransaction: BidRepository
	let item: ItemModel

	init(item: ItemModel, repositoryPerformTransaction: BidRepository) {
		self.item = item
		self.repositoryPerformTransaction = repositoryPerformTransaction
	}
}
