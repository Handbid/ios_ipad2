// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct ReceiptLineItemModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int
	var receiptsGuid: String?
	var auctionId: Int?
	var receiptId: Int?
	var itemId: Int?
	var name: String?
	var received: Bool?
	var quantity: Int?
	var pricePerItem: Int?
	var tax: Int?
	var taxRate: Int?
	var grandTotal: Int?
	var receiptTotal: Int?
	var receiptDue: Int?
	var item: ItemModel?
	var discount: Int?
	var fundraiserId: Int?
	var pageName: String?
	var paddleNumber: Int?
	var statusString: String?
	var statusType: StatusReceiptType?
	var bidType: String?
	var amount: Int?
	var dateInserted: Int?
	var dateUpdated: Int?
	var isPaid: Bool?

	enum StatusReceiptType: String, Codable {
		case winning, losing, purchase, failed, removed, new, bid, final_bid, max_bid, buy_now, sold_out, replaced, incomplete, winning_changed, transferred
	}
}

extension ReceiptLineItemModel: ArrowParsable {
	init() {
		self.id = Int()
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		receiptsGuid <-- json["receiptsGuid"]
		auctionId <-- json["auctionId"]
		receiptId <-- json["receiptId"]
		itemId <-- json["itemId"]
		name <-- json["name"]
		received <-- json["received"]
		quantity <-- json["quantity"]
		pricePerItem <-- json["pricePerItem"]
		tax <-- json["tax"]
		taxRate <-- json["taxRate"]
		grandTotal <-- json["grandTotal"]
		receiptTotal <-- json["receiptTotal"]
		receiptDue <-- json["receiptDue"]
		item <-- json["item"]
		discount <-- json["discount"]
		fundraiserId <-- json["fundraiserId"]
		pageName <-- json["pageName"]
		paddleNumber <-- json["paddleNumber"]
		bidType <-- json["bidType"]
		amount <-- json["amount"]
		dateInserted <-- json["dateInserted"]
		dateUpdated <-- json["dateUpdated"]
		isPaid <-- json["isPaid"]
		statusString <-- json["status"]

		if let statusString {
			statusType = StatusReceiptType(rawValue: statusString)
		}
	}
}
