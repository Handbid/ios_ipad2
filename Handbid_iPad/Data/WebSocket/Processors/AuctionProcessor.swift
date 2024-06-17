// Copyright (c) 2024 by Handbid. All rights reserved.

class AuctionProcessor: WebSocketProcessor {
	func process(data: [String: Any]) {
		do {
			let dataManager = DataManager.shared

			guard var currentAuction = try dataManager.fetchSingle(of: AuctionModel.self, from: .auction) else {
				return
			}

			guard let values = data["values"],
			      let updatedAuction = try? AuctionModel.decode(values)
			else { return }

			if updatedAuction.identity != currentAuction.identity {
				return
			}

			guard let attributes = data["attributes"],
			      let array = attributes as? [String]
			else { return }
			let changedFields = array.compactMap {
				AuctionModel.AuctionModelFields(rawValue: $0)
			}

			currentAuction.merge(with: updatedAuction, fields: changedFields)

			try dataManager.update(currentAuction, withNestedUpdates: true, in: .auction)
		}
		catch {
			print(error)
		}
	}
}
