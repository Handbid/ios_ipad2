// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class TicketModelTests: XCTestCase {
	func testTicketModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "itemGuid": "item_guid",
		    "name": "Test Ticket",
		    "status": "active",
		    "statusId": 1,
		    "categoryId": 2,
		    "categoryName": "Category",
		    "itemType": "type",
		    "isDirectPurchaseItem": true,
		    "isLive": false,
		    "isTicket": true,
		    "isPuzzle": false,
		    "isAppeal": false,
		    "availableForPreSale": true,
		    "buyNowPrice": 100.0,
		    "startingPrice": 10.0,
		    "bidIncrement": 5.0,
		    "minimumBidAmount": 15.0,
		    "description": "Ticket description",
		    "donor": "Donor",
		    "notables": "Notables",
		    "value": 200.0,
		    "currentPrice": 50.0,
		    "isRedeemable": false,
		    "highestBid": 55.0,
		    "highestProxyBid": 60.0,
		    "bidCount": 3,
		    "winnerId": 1,
		    "winningBidderName": "John Doe",
		    "redemptionInstructions": "Instructions",
		    "imageUrl": "https://example.com/image.jpg",
		    "images": [
		        {
		            "itemImageId": 1,
		            "itemImageGuid": "image_guid",
		            "itemImageCaption": "A caption",
		            "itemImageFileName": "image.jpg",
		            "itemImageUrl": "https://example.com/image.jpg"
		        }
		    ],
		    "videoEmbedCode": "embed_code",
		    "key": "key",
		    "itemCode": "code",
		    "quantitySold": 2,
		    "puzzlePiecesSold": 1,
		    "disableMobileBidding": true,
		    "hasInventory": false,
		    "inventoryRemaining": 0,
		    "inventoryTotal": 10,
		    "timerStartTime": 1622517800,
		    "timerEndTime": 1625109800,
		    "timerEndTimeGMT": "2021-07-01T00:00:00Z",
		    "timerRemaining": 2592000,
		    "isHidden": false,
		    "isBackendOnly": false,
		    "showValue": true,
		    "isBidpadOnly": false,
		    "ticketQuantity": 100,
		    "valueReceived": 150.0,
		    "admits": 2,
		    "ticketDeferredPaymentAllowed": true,
		    "ticketLimit": 5,
		    "surcharge": 2.5,
		    "surchargeName": "Surcharge",
		    "ticketInstructions": "Ticket instructions",
		    "ticketPaymentInstructions": "Ticket payment instructions",
		    "hideSales": false,
		    "isFeatured": true,
		    "isAvailableCheckin": true,
		    "valueAsPriceless": false,
		    "puzzlePiecesCount": 10,
		    "showPurchaserNames": true,
		    "instructionsPuzzle": "Puzzle instructions",
		    "isPromoted": true,
		    "reservePrice": 50.0,
		    "isPassed": false,
		    "hideFromPurchases": false,
		    "customFieldValues": ["Custom1", "Custom2"],
		    "customQuantitiesThreshold": [1, 2, 3],
		    "quantityParticipants": 10,
		    "isEditablePriorToSale": true,
		    "unitsType": "units",
		    "quantityLabel": "quantity",
		    "quantityUnitLabel": "unit",
		    "discountLabel": "discount",
		    "discountUnitLabel": "unit"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var ticketModel = TicketModel()
		ticketModel.deserialize(json)

		XCTAssertEqual(ticketModel.id, 1)
		XCTAssertEqual(ticketModel.itemGuid, "item_guid")
		XCTAssertEqual(ticketModel.name, "Test Ticket")
		XCTAssertEqual(ticketModel.status, "active")
		XCTAssertEqual(ticketModel.statusId, 1)
		XCTAssertEqual(ticketModel.categoryId, 2)
		XCTAssertEqual(ticketModel.categoryName, "Category")
		XCTAssertEqual(ticketModel.itemType, "type")
		XCTAssertEqual(ticketModel.isDirectPurchaseItem, true)
		XCTAssertEqual(ticketModel.isLive, false)
		XCTAssertEqual(ticketModel.isTicket, true)
		XCTAssertEqual(ticketModel.isPuzzle, false)
		XCTAssertEqual(ticketModel.isAppeal, false)
		XCTAssertEqual(ticketModel.availableForPreSale, true)
		XCTAssertEqual(ticketModel.buyNowPrice, 100.0)
		XCTAssertEqual(ticketModel.startingPrice, 10.0)
		XCTAssertEqual(ticketModel.bidIncrement, 5.0)
		XCTAssertEqual(ticketModel.minimumBidAmount, 15.0)
		XCTAssertEqual(ticketModel.description, "Ticket description")
		XCTAssertEqual(ticketModel.donor, "Donor")
		XCTAssertEqual(ticketModel.notables, "Notables")
		XCTAssertEqual(ticketModel.value, 200.0)
		XCTAssertEqual(ticketModel.currentPrice, 50.0)
		XCTAssertEqual(ticketModel.isRedeemable, false)
		XCTAssertEqual(ticketModel.highestBid, 55.0)
		XCTAssertEqual(ticketModel.highestProxyBid, 60.0)
		XCTAssertEqual(ticketModel.bidCount, 3)
		XCTAssertEqual(ticketModel.winnerId, 1)
		XCTAssertEqual(ticketModel.winningBidderName, "John Doe")
		XCTAssertEqual(ticketModel.redemptionInstructions, "Instructions")
		XCTAssertEqual(ticketModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(ticketModel.images?.count, 1)
		XCTAssertEqual(ticketModel.videoEmbedCode, "embed_code")
		XCTAssertEqual(ticketModel.key, "key")
		XCTAssertEqual(ticketModel.itemCode, "code")
		XCTAssertEqual(ticketModel.quantitySold, 2)
		XCTAssertEqual(ticketModel.puzzlePiecesSold, 1)
		XCTAssertEqual(ticketModel.disableMobileBidding, true)
		XCTAssertEqual(ticketModel.hasInventory, false)
		XCTAssertEqual(ticketModel.inventoryRemaining, 0)
		XCTAssertEqual(ticketModel.inventoryTotal, 10)
		XCTAssertEqual(ticketModel.timerStartTime, 1_622_517_800)
		XCTAssertEqual(ticketModel.timerEndTime, 1_625_109_800)
		XCTAssertEqual(ticketModel.timerEndTimeGMT, "2021-07-01T00:00:00Z")
		XCTAssertEqual(ticketModel.timerRemaining, 2_592_000)
		XCTAssertEqual(ticketModel.isHidden, false)
		XCTAssertEqual(ticketModel.isBackendOnly, false)
		XCTAssertEqual(ticketModel.showValue, true)
		XCTAssertEqual(ticketModel.isBidpadOnly, false)
		XCTAssertEqual(ticketModel.ticketQuantity, 100)
		XCTAssertEqual(ticketModel.valueReceived, 150.0)
		XCTAssertEqual(ticketModel.admits, 2)
		XCTAssertEqual(ticketModel.ticketDeferredPaymentAllowed, true)
		XCTAssertEqual(ticketModel.ticketLimit, 5)
		XCTAssertEqual(ticketModel.surcharge, 2.5)
		XCTAssertEqual(ticketModel.surchargeName, "Surcharge")
		XCTAssertEqual(ticketModel.ticketInstructions, "Ticket instructions")
		XCTAssertEqual(ticketModel.ticketPaymentInstructions, "Ticket payment instructions")
		XCTAssertEqual(ticketModel.hideSales, false)
		XCTAssertEqual(ticketModel.isFeatured, true)
		XCTAssertEqual(ticketModel.isAvailableCheckin, true)
		XCTAssertEqual(ticketModel.valueAsPriceless, false)
		XCTAssertEqual(ticketModel.puzzlePiecesCount, 10)
		XCTAssertEqual(ticketModel.showPurchaserNames, true)
		XCTAssertEqual(ticketModel.instructionsPuzzle, "Puzzle instructions")
		XCTAssertEqual(ticketModel.isPromoted, true)
		XCTAssertEqual(ticketModel.reservePrice, 50.0)
		XCTAssertEqual(ticketModel.isPassed, false)
		XCTAssertEqual(ticketModel.hideFromPurchases, false)
		XCTAssertEqual(ticketModel.customFieldValues, ["Custom1", "Custom2"])
		XCTAssertEqual(ticketModel.customQuantitiesThreshold, [1, 2, 3])
		XCTAssertEqual(ticketModel.quantityParticipants, 10)
		XCTAssertEqual(ticketModel.isEditablePriorToSale, true)
		XCTAssertEqual(ticketModel.unitsType, "units")
		XCTAssertEqual(ticketModel.quantityLabel, "quantity")
		XCTAssertEqual(ticketModel.quantityUnitLabel, "unit")
		XCTAssertEqual(ticketModel.discountLabel, "discount")
		XCTAssertEqual(ticketModel.discountUnitLabel, "unit")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var ticketModel = TicketModel()
		ticketModel.deserialize(json)

		XCTAssertNil(ticketModel.id)
		XCTAssertNil(ticketModel.itemGuid)
		XCTAssertNil(ticketModel.name)
		XCTAssertNil(ticketModel.status)
		XCTAssertNil(ticketModel.statusId)
		XCTAssertNil(ticketModel.categoryId)
		XCTAssertNil(ticketModel.categoryName)
		XCTAssertNil(ticketModel.itemType)
		XCTAssertNil(ticketModel.isDirectPurchaseItem)
		XCTAssertNil(ticketModel.isLive)
		XCTAssertNil(ticketModel.isTicket)
		XCTAssertNil(ticketModel.isPuzzle)
		XCTAssertNil(ticketModel.isAppeal)
		XCTAssertNil(ticketModel.availableForPreSale)
		XCTAssertNil(ticketModel.buyNowPrice)
		XCTAssertNil(ticketModel.startingPrice)
		XCTAssertNil(ticketModel.bidIncrement)
		XCTAssertNil(ticketModel.minimumBidAmount)
		XCTAssertNil(ticketModel.description)
		XCTAssertNil(ticketModel.donor)
		XCTAssertNil(ticketModel.notables)
		XCTAssertNil(ticketModel.value)
		XCTAssertNil(ticketModel.currentPrice)
		XCTAssertNil(ticketModel.isRedeemable)
		XCTAssertNil(ticketModel.highestBid)
		XCTAssertNil(ticketModel.highestProxyBid)
		XCTAssertNil(ticketModel.bidCount)
		XCTAssertNil(ticketModel.winnerId)
		XCTAssertNil(ticketModel.winningBidderName)
		XCTAssertNil(ticketModel.redemptionInstructions)
		XCTAssertNil(ticketModel.imageUrl)
		XCTAssertNil(ticketModel.videoEmbedCode)
		XCTAssertNil(ticketModel.key)
		XCTAssertNil(ticketModel.itemCode)
		XCTAssertNil(ticketModel.quantitySold)
		XCTAssertNil(ticketModel.puzzlePiecesSold)
		XCTAssertNil(ticketModel.disableMobileBidding)
		XCTAssertNil(ticketModel.hasInventory)
		XCTAssertNil(ticketModel.inventoryRemaining)
		XCTAssertNil(ticketModel.inventoryTotal)
		XCTAssertNil(ticketModel.timerStartTime)
		XCTAssertNil(ticketModel.timerEndTime)
		XCTAssertNil(ticketModel.timerEndTimeGMT)
		XCTAssertNil(ticketModel.timerRemaining)
		XCTAssertNil(ticketModel.isHidden)
		XCTAssertNil(ticketModel.isBackendOnly)
		XCTAssertNil(ticketModel.showValue)
		XCTAssertNil(ticketModel.isBidpadOnly)
		XCTAssertNil(ticketModel.ticketQuantity)
		XCTAssertNil(ticketModel.valueReceived)
		XCTAssertNil(ticketModel.admits)
		XCTAssertNil(ticketModel.ticketDeferredPaymentAllowed)
		XCTAssertNil(ticketModel.ticketLimit)
		XCTAssertNil(ticketModel.surcharge)
		XCTAssertNil(ticketModel.surchargeName)
		XCTAssertNil(ticketModel.ticketInstructions)
		XCTAssertNil(ticketModel.ticketPaymentInstructions)
		XCTAssertNil(ticketModel.hideSales)
		XCTAssertNil(ticketModel.isFeatured)
		XCTAssertNil(ticketModel.isAvailableCheckin)
		XCTAssertNil(ticketModel.valueAsPriceless)
		XCTAssertNil(ticketModel.puzzlePiecesCount)
		XCTAssertNil(ticketModel.showPurchaserNames)
		XCTAssertNil(ticketModel.instructionsPuzzle)
		XCTAssertNil(ticketModel.isPromoted)
		XCTAssertNil(ticketModel.reservePrice)
		XCTAssertNil(ticketModel.isPassed)
		XCTAssertNil(ticketModel.hideFromPurchases)
		XCTAssertNil(ticketModel.customFieldValues)
		XCTAssertNil(ticketModel.customQuantitiesThreshold)
		XCTAssertNil(ticketModel.quantityParticipants)
		XCTAssertNil(ticketModel.isEditablePriorToSale)
		XCTAssertNil(ticketModel.unitsType)
		XCTAssertNil(ticketModel.quantityLabel)
		XCTAssertNil(ticketModel.quantityUnitLabel)
		XCTAssertNil(ticketModel.discountLabel)
		XCTAssertNil(ticketModel.discountUnitLabel)
		XCTAssertTrue(ticketModel.images?.isEmpty ?? true)
	}
}
