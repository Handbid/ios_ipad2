// Copyright (c) 2024 by Handbid. All rights reserved.

class ItemProcessor: WebSocketProcessor {
	func process(data: [String: Any]) {
		do {
			let dataManager = DataManager.shared

			guard var currentAuction = try dataManager.fetchSingle(of: AuctionModel.self, from: .auction) else {
				return
			}

			guard let values = data["values"] as? [String: Any],
			      let updatedItem = try? ItemModel.decode(values)
			else {
				return
			}

			guard let attributes = data["attributes"] as? [String] else {
				return
			}

			if let categoryIndex = currentAuction.categories?.firstIndex(where: { category in
				category.items?.contains(where: { $0.id == updatedItem.id }) ?? false
			}) {
				if let itemIndexInCategory = currentAuction.categories?[categoryIndex].items?.firstIndex(where: { $0.id == updatedItem.id }) {
					currentAuction.categories?[categoryIndex].items?[itemIndexInCategory] = updatedItem
				}
			}

			let changedFields = attributes.compactMap {
				AuctionModel.AuctionModelFields(rawValue: $0)
			}

			currentAuction.merge(with: currentAuction, fields: changedFields)

			try dataManager.update(currentAuction, withNestedUpdates: true, in: .auction)
		}
		catch {
			print(error)
		}
	}
}
