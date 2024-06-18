// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct CategoryModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int?
	var name: String?
	var auctionId: Int?
	var items: [ItemModel]?
}

extension CategoryModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		name <-- json["name"]
		auctionId <-- json["auctionId"]

		items = (json["items"]?.collection ?? [json["items"]].compactMap { $0 }).map { jsonItem in
			var items = ItemModel()
			items.deserialize(jsonItem)
			return items
		}
	}
}
