// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class PromotedItemModelTests: XCTestCase {
	func testPromotedItemModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "itemGuid": "item_guid",
		    "name": "Test Promoted Item",
		    "status": "active",
		    "statusId": 1,
		    "categoryId": 2,
		    "categoryName": "Category",
		    "itemType": "type",
		    "isDirectPurchaseItem": true,
		    "isLive": false,
		    "isTicket": false,
		    "isPuzzle": false,
		    "isAppeal": false,
		    "availableForPreSale": true,
		    "buyNowPrice": 100.0,
		    "startingPrice": 10.0,
		    "bidIncrement": 5.0,
		    "minimumBidAmount": 15.0,
		    "description": "Promoted Item description",
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

		var promotedItemModel = PromotedItemModel()
		promotedItemModel.deserialize(json)

		XCTAssertEqual(promotedItemModel.id, 1)
		XCTAssertEqual(promotedItemModel.itemGuid, "item_guid")
		XCTAssertEqual(promotedItemModel.name, "Test Promoted Item")
		XCTAssertEqual(promotedItemModel.status, "active")
		XCTAssertEqual(promotedItemModel.statusId, 1)
		XCTAssertEqual(promotedItemModel.categoryId, 2)
		XCTAssertEqual(promotedItemModel.categoryName, "Category")
		XCTAssertEqual(promotedItemModel.itemType, "type")
		XCTAssertEqual(promotedItemModel.isDirectPurchaseItem, true)
		XCTAssertEqual(promotedItemModel.isLive, false)
		XCTAssertEqual(promotedItemModel.isTicket, false)
		XCTAssertEqual(promotedItemModel.isPuzzle, false)
		XCTAssertEqual(promotedItemModel.isAppeal, false)
		XCTAssertEqual(promotedItemModel.availableForPreSale, true)
		XCTAssertEqual(promotedItemModel.buyNowPrice, 100.0)
		XCTAssertEqual(promotedItemModel.startingPrice, 10.0)
		XCTAssertEqual(promotedItemModel.bidIncrement, 5.0)
		XCTAssertEqual(promotedItemModel.minimumBidAmount, 15.0)
		XCTAssertEqual(promotedItemModel.description, "Promoted Item description")
		XCTAssertEqual(promotedItemModel.donor, "Donor")
		XCTAssertEqual(promotedItemModel.notables, "Notables")
		XCTAssertEqual(promotedItemModel.value, 200.0)
		XCTAssertEqual(promotedItemModel.currentPrice, 50.0)
		XCTAssertEqual(promotedItemModel.isRedeemable, false)
		XCTAssertEqual(promotedItemModel.highestBid, 55.0)
		XCTAssertEqual(promotedItemModel.highestProxyBid, 60.0)
		XCTAssertEqual(promotedItemModel.bidCount, 3)
		XCTAssertEqual(promotedItemModel.winnerId, 1)
		XCTAssertEqual(promotedItemModel.winningBidderName, "John Doe")
		XCTAssertEqual(promotedItemModel.redemptionInstructions, "Instructions")
		XCTAssertEqual(promotedItemModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(promotedItemModel.images?.count, 1)
		XCTAssertEqual(promotedItemModel.videoEmbedCode, "embed_code")
		XCTAssertEqual(promotedItemModel.key, "key")
		XCTAssertEqual(promotedItemModel.itemCode, "code")
		XCTAssertEqual(promotedItemModel.quantitySold, 2)
		XCTAssertEqual(promotedItemModel.puzzlePiecesSold, 1)
		XCTAssertEqual(promotedItemModel.disableMobileBidding, true)
		XCTAssertEqual(promotedItemModel.hasInventory, false)
		XCTAssertEqual(promotedItemModel.inventoryRemaining, 0)
		XCTAssertEqual(promotedItemModel.inventoryTotal, 10)
		XCTAssertEqual(promotedItemModel.timerStartTime, 1_622_517_800)
		XCTAssertEqual(promotedItemModel.timerEndTime, 1_625_109_800)
		XCTAssertEqual(promotedItemModel.timerEndTimeGMT, "2021-07-01T00:00:00Z")
		XCTAssertEqual(promotedItemModel.timerRemaining, 2_592_000)
		XCTAssertEqual(promotedItemModel.isHidden, false)
		XCTAssertEqual(promotedItemModel.isBackendOnly, false)
		XCTAssertEqual(promotedItemModel.showValue, true)
		XCTAssertEqual(promotedItemModel.isBidpadOnly, false)
		XCTAssertEqual(promotedItemModel.ticketQuantity, 100)
		XCTAssertEqual(promotedItemModel.valueReceived, 150.0)
		XCTAssertEqual(promotedItemModel.admits, 2)
		XCTAssertEqual(promotedItemModel.ticketDeferredPaymentAllowed, true)
		XCTAssertEqual(promotedItemModel.ticketLimit, 5)
		XCTAssertEqual(promotedItemModel.surcharge, 2.5)
		XCTAssertEqual(promotedItemModel.surchargeName, "Surcharge")
		XCTAssertEqual(promotedItemModel.ticketInstructions, "Ticket instructions")
		XCTAssertEqual(promotedItemModel.ticketPaymentInstructions, "Ticket payment instructions")
		XCTAssertEqual(promotedItemModel.hideSales, false)
		XCTAssertEqual(promotedItemModel.isFeatured, true)
		XCTAssertEqual(promotedItemModel.isAvailableCheckin, true)
		XCTAssertEqual(promotedItemModel.valueAsPriceless, false)
		XCTAssertEqual(promotedItemModel.puzzlePiecesCount, 10)
		XCTAssertEqual(promotedItemModel.showPurchaserNames, true)
		XCTAssertEqual(promotedItemModel.instructionsPuzzle, "Puzzle instructions")
		XCTAssertEqual(promotedItemModel.isPromoted, true)
		XCTAssertEqual(promotedItemModel.reservePrice, 50.0)
		XCTAssertEqual(promotedItemModel.isPassed, false)
		XCTAssertEqual(promotedItemModel.hideFromPurchases, false)
		XCTAssertEqual(promotedItemModel.customFieldValues, ["Custom1", "Custom2"])
		XCTAssertEqual(promotedItemModel.customQuantitiesThreshold, [1, 2, 3])
		XCTAssertEqual(promotedItemModel.quantityParticipants, 10)
		XCTAssertEqual(promotedItemModel.isEditablePriorToSale, true)
		XCTAssertEqual(promotedItemModel.unitsType, "units")
		XCTAssertEqual(promotedItemModel.quantityLabel, "quantity")
		XCTAssertEqual(promotedItemModel.quantityUnitLabel, "unit")
		XCTAssertEqual(promotedItemModel.discountLabel, "discount")
		XCTAssertEqual(promotedItemModel.discountUnitLabel, "unit")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var promotedItemModel = PromotedItemModel()
		promotedItemModel.deserialize(json)

		XCTAssertNil(promotedItemModel.id)
		XCTAssertNil(promotedItemModel.itemGuid)
		XCTAssertNil(promotedItemModel.name)
		XCTAssertNil(promotedItemModel.status)
		XCTAssertNil(promotedItemModel.statusId)
		XCTAssertNil(promotedItemModel.categoryId)
		XCTAssertNil(promotedItemModel.categoryName)
		XCTAssertNil(promotedItemModel.itemType)
		XCTAssertNil(promotedItemModel.isDirectPurchaseItem)
		XCTAssertNil(promotedItemModel.isLive)
		XCTAssertNil(promotedItemModel.isTicket)
		XCTAssertNil(promotedItemModel.isPuzzle)
		XCTAssertNil(promotedItemModel.isAppeal)
		XCTAssertNil(promotedItemModel.availableForPreSale)
		XCTAssertNil(promotedItemModel.buyNowPrice)
		XCTAssertNil(promotedItemModel.startingPrice)
		XCTAssertNil(promotedItemModel.bidIncrement)
		XCTAssertNil(promotedItemModel.minimumBidAmount)
		XCTAssertNil(promotedItemModel.description)
		XCTAssertNil(promotedItemModel.donor)
		XCTAssertNil(promotedItemModel.notables)
		XCTAssertNil(promotedItemModel.value)
		XCTAssertNil(promotedItemModel.currentPrice)
		XCTAssertNil(promotedItemModel.isRedeemable)
		XCTAssertNil(promotedItemModel.highestBid)
		XCTAssertNil(promotedItemModel.highestProxyBid)
		XCTAssertNil(promotedItemModel.bidCount)
		XCTAssertNil(promotedItemModel.winnerId)
		XCTAssertNil(promotedItemModel.winningBidderName)
		XCTAssertNil(promotedItemModel.redemptionInstructions)
		XCTAssertNil(promotedItemModel.imageUrl)
		XCTAssertNil(promotedItemModel.videoEmbedCode)
		XCTAssertNil(promotedItemModel.key)
		XCTAssertNil(promotedItemModel.itemCode)
		XCTAssertNil(promotedItemModel.quantitySold)
		XCTAssertNil(promotedItemModel.puzzlePiecesSold)
		XCTAssertNil(promotedItemModel.disableMobileBidding)
		XCTAssertNil(promotedItemModel.hasInventory)
		XCTAssertNil(promotedItemModel.inventoryRemaining)
		XCTAssertNil(promotedItemModel.inventoryTotal)
		XCTAssertNil(promotedItemModel.timerStartTime)
		XCTAssertNil(promotedItemModel.timerEndTime)
		XCTAssertNil(promotedItemModel.timerEndTimeGMT)
		XCTAssertNil(promotedItemModel.timerRemaining)
		XCTAssertNil(promotedItemModel.isHidden)
		XCTAssertNil(promotedItemModel.isBackendOnly)
		XCTAssertNil(promotedItemModel.showValue)
		XCTAssertNil(promotedItemModel.isBidpadOnly)
		XCTAssertNil(promotedItemModel.ticketQuantity)
		XCTAssertNil(promotedItemModel.valueReceived)
		XCTAssertNil(promotedItemModel.admits)
		XCTAssertNil(promotedItemModel.ticketDeferredPaymentAllowed)
		XCTAssertNil(promotedItemModel.ticketLimit)
		XCTAssertNil(promotedItemModel.surcharge)
		XCTAssertNil(promotedItemModel.surchargeName)
		XCTAssertNil(promotedItemModel.ticketInstructions)
		XCTAssertNil(promotedItemModel.ticketPaymentInstructions)
		XCTAssertNil(promotedItemModel.hideSales)
		XCTAssertNil(promotedItemModel.isFeatured)
		XCTAssertNil(promotedItemModel.isAvailableCheckin)
		XCTAssertNil(promotedItemModel.valueAsPriceless)
		XCTAssertNil(promotedItemModel.puzzlePiecesCount)
		XCTAssertNil(promotedItemModel.showPurchaserNames)
		XCTAssertNil(promotedItemModel.instructionsPuzzle)
		XCTAssertNil(promotedItemModel.isPromoted)
		XCTAssertNil(promotedItemModel.reservePrice)
		XCTAssertNil(promotedItemModel.isPassed)
		XCTAssertNil(promotedItemModel.hideFromPurchases)
		XCTAssertNil(promotedItemModel.customFieldValues)
		XCTAssertNil(promotedItemModel.customQuantitiesThreshold)
		XCTAssertNil(promotedItemModel.quantityParticipants)
		XCTAssertNil(promotedItemModel.isEditablePriorToSale)
		XCTAssertNil(promotedItemModel.unitsType)
		XCTAssertNil(promotedItemModel.quantityLabel)
		XCTAssertNil(promotedItemModel.quantityUnitLabel)
		XCTAssertNil(promotedItemModel.discountLabel)
		XCTAssertNil(promotedItemModel.discountUnitLabel)
		XCTAssertTrue(promotedItemModel.images?.isEmpty ?? true)
	}
}
