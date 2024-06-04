// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class ItemModelTests: XCTestCase {
	func testItemModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "itemGuid": "item_guid",
		    "name": "Test Item",
		    "status": "active",
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
		    "description": "Item description",
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

		var itemModel = ItemModel()
		itemModel.deserialize(json)

		XCTAssertEqual(itemModel.id, 1)
		XCTAssertEqual(itemModel.itemGuid, "item_guid")
		XCTAssertEqual(itemModel.name, "Test Item")
		XCTAssertEqual(itemModel.status, "active")
		XCTAssertEqual(itemModel.categoryId, 2)
		XCTAssertEqual(itemModel.categoryName, "Category")
		XCTAssertEqual(itemModel.itemType, "type")
		XCTAssertEqual(itemModel.isDirectPurchaseItem, true)
		XCTAssertEqual(itemModel.isLive, false)
		XCTAssertEqual(itemModel.isTicket, false)
		XCTAssertEqual(itemModel.isPuzzle, false)
		XCTAssertEqual(itemModel.isAppeal, false)
		XCTAssertEqual(itemModel.availableForPreSale, true)
		XCTAssertEqual(itemModel.buyNowPrice, 100.0)
		XCTAssertEqual(itemModel.startingPrice, 10.0)
		XCTAssertEqual(itemModel.bidIncrement, 5.0)
		XCTAssertEqual(itemModel.minimumBidAmount, 15.0)
		XCTAssertEqual(itemModel.description, "Item description")
		XCTAssertEqual(itemModel.donor, "Donor")
		XCTAssertEqual(itemModel.notables, "Notables")
		XCTAssertEqual(itemModel.value, 200.0)
		XCTAssertEqual(itemModel.currentPrice, 50.0)
		XCTAssertEqual(itemModel.isRedeemable, false)
		XCTAssertEqual(itemModel.highestBid, 55.0)
		XCTAssertEqual(itemModel.highestProxyBid, 60.0)
		XCTAssertEqual(itemModel.bidCount, 3)
		XCTAssertEqual(itemModel.winnerId, 1)
		XCTAssertEqual(itemModel.winningBidderName, "John Doe")
		XCTAssertEqual(itemModel.redemptionInstructions, "Instructions")
		XCTAssertEqual(itemModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(itemModel.images?.count, 1)
		XCTAssertEqual(itemModel.videoEmbedCode, "embed_code")
		XCTAssertEqual(itemModel.key, "key")
		XCTAssertEqual(itemModel.itemCode, "code")
		XCTAssertEqual(itemModel.quantitySold, 2)
		XCTAssertEqual(itemModel.puzzlePiecesSold, 1)
		XCTAssertEqual(itemModel.disableMobileBidding, true)
		XCTAssertEqual(itemModel.hasInventory, false)
		XCTAssertEqual(itemModel.inventoryRemaining, 0)
		XCTAssertEqual(itemModel.inventoryTotal, 10)
		XCTAssertEqual(itemModel.timerStartTime, 1_622_517_800)
		XCTAssertEqual(itemModel.timerEndTime, 1_625_109_800)
		XCTAssertEqual(itemModel.timerEndTimeGMT, "2021-07-01T00:00:00Z")
		XCTAssertEqual(itemModel.timerRemaining, 2_592_000)
		XCTAssertEqual(itemModel.isHidden, false)
		XCTAssertEqual(itemModel.isBackendOnly, false)
		XCTAssertEqual(itemModel.showValue, true)
		XCTAssertEqual(itemModel.isBidpadOnly, false)
		XCTAssertEqual(itemModel.ticketQuantity, 100)
		XCTAssertEqual(itemModel.valueReceived, 150.0)
		XCTAssertEqual(itemModel.admits, 2)
		XCTAssertEqual(itemModel.ticketDeferredPaymentAllowed, true)
		XCTAssertEqual(itemModel.ticketLimit, 5)
		XCTAssertEqual(itemModel.surcharge, 2.5)
		XCTAssertEqual(itemModel.surchargeName, "Surcharge")
		XCTAssertEqual(itemModel.ticketInstructions, "Ticket instructions")
		XCTAssertEqual(itemModel.ticketPaymentInstructions, "Ticket payment instructions")
		XCTAssertEqual(itemModel.hideSales, false)
		XCTAssertEqual(itemModel.isFeatured, true)
		XCTAssertEqual(itemModel.isAvailableCheckin, true)
		XCTAssertEqual(itemModel.valueAsPriceless, false)
		XCTAssertEqual(itemModel.puzzlePiecesCount, 10)
		XCTAssertEqual(itemModel.showPurchaserNames, true)
		XCTAssertEqual(itemModel.instructionsPuzzle, "Puzzle instructions")
		XCTAssertEqual(itemModel.isPromoted, true)
		XCTAssertEqual(itemModel.reservePrice, 50.0)
		XCTAssertEqual(itemModel.isPassed, false)
		XCTAssertEqual(itemModel.hideFromPurchases, false)
		XCTAssertEqual(itemModel.customFieldValues, ["Custom1", "Custom2"])
		XCTAssertEqual(itemModel.customQuantitiesThreshold, [1, 2, 3])
		XCTAssertEqual(itemModel.quantityParticipants, 10)
		XCTAssertEqual(itemModel.isEditablePriorToSale, true)
		XCTAssertEqual(itemModel.unitsType, "units")
		XCTAssertEqual(itemModel.quantityLabel, "quantity")
		XCTAssertEqual(itemModel.quantityUnitLabel, "unit")
		XCTAssertEqual(itemModel.discountLabel, "discount")
		XCTAssertEqual(itemModel.discountUnitLabel, "unit")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var itemModel = ItemModel()
		itemModel.deserialize(json)

		XCTAssertNil(itemModel.id)
		XCTAssertNil(itemModel.itemGuid)
		XCTAssertNil(itemModel.name)
		XCTAssertNil(itemModel.status)
		XCTAssertNil(itemModel.categoryId)
		XCTAssertNil(itemModel.categoryName)
		XCTAssertNil(itemModel.itemType)
		XCTAssertNil(itemModel.isDirectPurchaseItem)
		XCTAssertNil(itemModel.isLive)
		XCTAssertNil(itemModel.isTicket)
		XCTAssertNil(itemModel.isPuzzle)
		XCTAssertNil(itemModel.isAppeal)
		XCTAssertNil(itemModel.availableForPreSale)
		XCTAssertNil(itemModel.buyNowPrice)
		XCTAssertNil(itemModel.startingPrice)
		XCTAssertNil(itemModel.bidIncrement)
		XCTAssertNil(itemModel.minimumBidAmount)
		XCTAssertNil(itemModel.description)
		XCTAssertNil(itemModel.donor)
		XCTAssertNil(itemModel.notables)
		XCTAssertNil(itemModel.value)
		XCTAssertNil(itemModel.currentPrice)
		XCTAssertNil(itemModel.isRedeemable)
		XCTAssertNil(itemModel.highestBid)
		XCTAssertNil(itemModel.highestProxyBid)
		XCTAssertNil(itemModel.bidCount)
		XCTAssertNil(itemModel.winnerId)
		XCTAssertNil(itemModel.winningBidderName)
		XCTAssertNil(itemModel.redemptionInstructions)
		XCTAssertNil(itemModel.imageUrl)
		XCTAssertNil(itemModel.videoEmbedCode)
		XCTAssertNil(itemModel.key)
		XCTAssertNil(itemModel.itemCode)
		XCTAssertNil(itemModel.quantitySold)
		XCTAssertNil(itemModel.puzzlePiecesSold)
		XCTAssertNil(itemModel.disableMobileBidding)
		XCTAssertNil(itemModel.hasInventory)
		XCTAssertNil(itemModel.inventoryRemaining)
		XCTAssertNil(itemModel.inventoryTotal)
		XCTAssertNil(itemModel.timerStartTime)
		XCTAssertNil(itemModel.timerEndTime)
		XCTAssertNil(itemModel.timerEndTimeGMT)
		XCTAssertNil(itemModel.timerRemaining)
		XCTAssertNil(itemModel.isHidden)
		XCTAssertNil(itemModel.isBackendOnly)
		XCTAssertNil(itemModel.showValue)
		XCTAssertNil(itemModel.isBidpadOnly)
		XCTAssertNil(itemModel.ticketQuantity)
		XCTAssertNil(itemModel.valueReceived)
		XCTAssertNil(itemModel.admits)
		XCTAssertNil(itemModel.ticketDeferredPaymentAllowed)
		XCTAssertNil(itemModel.ticketLimit)
		XCTAssertNil(itemModel.surcharge)
		XCTAssertNil(itemModel.surchargeName)
		XCTAssertNil(itemModel.ticketInstructions)
		XCTAssertNil(itemModel.ticketPaymentInstructions)
		XCTAssertNil(itemModel.hideSales)
		XCTAssertNil(itemModel.isFeatured)
		XCTAssertNil(itemModel.isAvailableCheckin)
		XCTAssertNil(itemModel.valueAsPriceless)
		XCTAssertNil(itemModel.puzzlePiecesCount)
		XCTAssertNil(itemModel.showPurchaserNames)
		XCTAssertNil(itemModel.instructionsPuzzle)
		XCTAssertNil(itemModel.isPromoted)
		XCTAssertNil(itemModel.reservePrice)
		XCTAssertNil(itemModel.isPassed)
		XCTAssertNil(itemModel.hideFromPurchases)
		XCTAssertNil(itemModel.customFieldValues)
		XCTAssertNil(itemModel.customQuantitiesThreshold)
		XCTAssertNil(itemModel.quantityParticipants)
		XCTAssertNil(itemModel.isEditablePriorToSale)
		XCTAssertNil(itemModel.unitsType)
		XCTAssertNil(itemModel.quantityLabel)
		XCTAssertNil(itemModel.quantityUnitLabel)
		XCTAssertNil(itemModel.discountLabel)
		XCTAssertNil(itemModel.discountUnitLabel)
		XCTAssertTrue(itemModel.images?.isEmpty ?? true)
	}
}
