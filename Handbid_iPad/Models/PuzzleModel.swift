// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct PuzzleModel: Decodable, NetworkingJSONDecodable {
	var id: Int?
	var itemGuid: String?
	var name: String?
	var status: String?
	var statusId: Int?
	var categoryId: Int?
	var categoryName: String?
	var itemType: String?
	var isDirectPurchaseItem: Bool?
	var isLive: Bool?
	var isTicket: Bool?
	var isPuzzle: Bool?
	var isAppeal: Bool?
	var availableForPreSale: Bool?
	var buyNowPrice: Double?
	var startingPrice: Double?
	var bidIncrement: Double?
	var minimumBidAmount: Double?
	var description: String?
	var donor: String?
	var notables: String?
	var value: Double?
	var currentPrice: Double?
	var isRedeemable: Bool?
	var highestBid: Double?
	var highestProxyBid: Double?
	var bidCount: Int?
	var winnerId: Int?
	var winningBidderName: String?
	var redemptionInstructions: String?
	var imageUrl: String?
	var images: [ItemImageModel]?
	var videoEmbedCode: String?
	var key: String?
	var itemCode: String?
	var quantitySold: Int?
	var puzzlePiecesSold: Int?
	var disableMobileBidding: Bool?
	var hasInventory: Bool?
	var inventoryRemaining: Int?
	var inventoryTotal: Int?
	var timerStartTime: Int?
	var timerEndTime: Int?
	var timerEndTimeGMT: String?
	var timerRemaining: Int?
	var isHidden: Bool?
	var isBackendOnly: Bool?
	var showValue: Bool?
	var isBidpadOnly: Bool?
	var ticketQuantity: Int?
	var valueReceived: Double?
	var admits: Int?
	var ticketDeferredPaymentAllowed: Bool?
	var ticketLimit: Int?
	var surcharge: Double?
	var surchargeName: String?
	var ticketInstructions: String?
	var ticketPaymentInstructions: String?
	var hideSales: Bool?
	var isFeatured: Bool?
	var isAvailableCheckin: Bool?
	var valueAsPriceless: Bool?
	var puzzlePiecesCount: Int?
	var showPurchaserNames: Bool?
	var instructionsPuzzle: String?
	var isPromoted: Bool?
	var reservePrice: Double?
	var isPassed: Bool?
	var hideFromPurchases: Bool?
	var customFieldValues: [String]?
	// var safety: ChemicalElementsModel?
	var customQuantitiesThreshold: [Int]?
	var quantityParticipants: Int?
	var isEditablePriorToSale: Bool?
	var unitsType: String?
	var quantityLabel: String?
	var quantityUnitLabel: String?
	var discountLabel: String?
	var discountUnitLabel: String?
}

extension PuzzleModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		itemGuid <-- json["itemGuid"]
		name <-- json["name"]
		status <-- json["status"]
		statusId <-- json["statusId"]
		categoryId <-- json["categoryId"]
		categoryName <-- json["categoryName"]
		itemType <-- json["itemType"]
		isDirectPurchaseItem <-- json["isDirectPurchaseItem"]
		isLive <-- json["isLive"]
		isTicket <-- json["isTicket"]
		isPuzzle <-- json["isPuzzle"]
		isAppeal <-- json["isAppeal"]
		availableForPreSale <-- json["availableForPreSale"]
		buyNowPrice <-- json["buyNowPrice"]
		startingPrice <-- json["startingPrice"]
		bidIncrement <-- json["bidIncrement"]
		minimumBidAmount <-- json["minimumBidAmount"]
		description <-- json["description"]
		donor <-- json["donor"]
		notables <-- json["notables"]
		value <-- json["value"]
		currentPrice <-- json["currentPrice"]
		isRedeemable <-- json["isRedeemable"]
		highestBid <-- json["highestBid"]
		highestProxyBid <-- json["highestProxyBid"]
		bidCount <-- json["bidCount"]
		winnerId <-- json["winnerId"]
		winningBidderName <-- json["winningBidderName"]
		redemptionInstructions <-- json["redemptionInstructions"]
		imageUrl <-- json["imageUrl"]
		videoEmbedCode <-- json["videoEmbedCode"]
		key <-- json["key"]
		itemCode <-- json["itemCode"]
		quantitySold <-- json["quantitySold"]
		puzzlePiecesSold <-- json["puzzlePiecesSold"]
		disableMobileBidding <-- json["disableMobileBidding"]
		hasInventory <-- json["hasInventory"]
		inventoryRemaining <-- json["inventoryRemaining"]
		inventoryTotal <-- json["inventoryTotal"]
		timerStartTime <-- json["timerStartTime"]
		timerEndTime <-- json["timerEndTime"]
		timerEndTimeGMT <-- json["timerEndTimeGMT"]
		timerRemaining <-- json["timerRemaining"]
		isHidden <-- json["isHidden"]
		isBackendOnly <-- json["isBackendOnly"]
		showValue <-- json["showValue"]
		isBidpadOnly <-- json["isBidpadOnly"]
		ticketQuantity <-- json["ticketQuantity"]
		valueReceived <-- json["valueReceived"]
		admits <-- json["admits"]
		ticketDeferredPaymentAllowed <-- json["ticketDeferredPaymentAllowed"]
		ticketLimit <-- json["ticketLimit"]
		surcharge <-- json["surcharge"]
		surchargeName <-- json["surchargeName"]
		ticketInstructions <-- json["ticketInstructions"]
		ticketPaymentInstructions <-- json["ticketPaymentInstructions"]
		hideSales <-- json["hideSales"]
		isFeatured <-- json["isFeatured"]
		isAvailableCheckin <-- json["isAvailableCheckin"]
		valueAsPriceless <-- json["valueAsPriceless"]
		puzzlePiecesCount <-- json["puzzlePiecesCount"]
		showPurchaserNames <-- json["showPurchaserNames"]
		instructionsPuzzle <-- json["instructionsPuzzle"]
		isPromoted <-- json["isPromoted"]
		reservePrice <-- json["reservePrice"]
		isPassed <-- json["isPassed"]
		hideFromPurchases <-- json["hideFromPurchases"]
		customFieldValues <-- json["customFieldValues"]
		customQuantitiesThreshold <-- json["customQuantitiesThreshold"]
		quantityParticipants <-- json["quantityParticipants"]
		isEditablePriorToSale <-- json["isEditablePriorToSale"]
		unitsType <-- json["unitsType"]
		quantityLabel <-- json["quantityLabel"]
		quantityUnitLabel <-- json["quantityUnitLabel"]
		discountLabel <-- json["discountLabel"]
		discountUnitLabel <-- json["discountUnitLabel"]

		images = (json["images"]?.collection ?? [json["images"]].compactMap { $0 }).map { jsonItem in
			var images = ItemImageModel()
			images.deserialize(jsonItem)
			return images
		}
	}
}
