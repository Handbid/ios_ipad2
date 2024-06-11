// Copyright (c) 2024 by Handbid. All rights reserved.

class AuctionProcessor: WebSocketProcessor {
	func process(data: Data) {
		do {
			let message = try WebSocketMessageModel<AuctionModel>.decode(data)
			let dataManager = DataManager.shared

			guard var currentAuction = try dataManager.fetchSingle(of: AuctionModel.self, from: .auction) else {
				return
			}

			guard let updatedAuction = message.values else { return }

			if updatedAuction.identity != currentAuction.identity {
				return
			}

			let changedFields = message.attributes.compactMap {
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
