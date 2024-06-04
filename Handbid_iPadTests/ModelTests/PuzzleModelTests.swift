// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class PuzzleModelTests: XCTestCase {
	func testPuzzleModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "itemGuid": "item_guid",
		    "name": "Puzzle Item",
		    "status": "available",
		    "statusId": 2,
		    "categoryId": 3,
		    "categoryName": "Puzzles",
		    "itemType": "puzzle",
		    "isDirectPurchaseItem": true,
		    "isLive": false,
		    "isTicket": false,
		    "isPuzzle": true,
		    "isAppeal": false,
		    "availableForPreSale": false,
		    "buyNowPrice": 20.0,
		    "startingPrice": 10.0,
		    "bidIncrement": 1.0,
		    "minimumBidAmount": 11.0,
		    "description": "A challenging puzzle.",
		    "donor": "Puzzle Company",
		    "notables": "Notable features of the puzzle.",
		    "value": 25.0,
		    "currentPrice": 15.0,
		    "isRedeemable": true,
		    "highestBid": 17.0,
		    "highestProxyBid": 18.0,
		    "bidCount": 3,
		    "winnerId": 4,
		    "winningBidderName": "Jane Doe",
		    "redemptionInstructions": "Contact support.",
		    "imageUrl": "https://example.com/puzzle.jpg",
		    "images": [
		        {
		            "itemImageId": 1,
		            "itemImageGuid": "image_guid",
		            "itemImageCaption": "A caption",
		            "itemImageFileName": "image.jpg",
		            "itemImageUrl": "https://example.com/image.jpg"
		        }
		    ],
		    "videoEmbedCode": "video_code",
		    "key": "puzzle_key",
		    "itemCode": "PZ123",
		    "quantitySold": 5,
		    "puzzlePiecesSold": 10,
		    "disableMobileBidding": false,
		    "hasInventory": true,
		    "inventoryRemaining": 20,
		    "inventoryTotal": 25,
		    "timerStartTime": 0,
		    "timerEndTime": 0,
		    "timerEndTimeGMT": "2023-01-01T00:00:00Z",
		    "timerRemaining": 0,
		    "isHidden": false,
		    "isBackendOnly": false,
		    "showValue": true,
		    "isBidpadOnly": false,
		    "ticketQuantity": 0,
		    "valueReceived": 0.0,
		    "admits": 0,
		    "ticketDeferredPaymentAllowed": false,
		    "ticketLimit": 0,
		    "surcharge": 0.0,
		    "surchargeName": "",
		    "ticketInstructions": "",
		    "ticketPaymentInstructions": "",
		    "hideSales": false,
		    "isFeatured": false,
		    "isAvailableCheckin": false,
		    "valueAsPriceless": false,
		    "puzzlePiecesCount": 1000,
		    "showPurchaserNames": false,
		    "instructionsPuzzle": "Some instructions",
		    "isPromoted": true,
		    "reservePrice": 0.0,
		    "isPassed": false,
		    "hideFromPurchases": false,
		    "customFieldValues": [],
		    "customQuantitiesThreshold": [],
		    "quantityParticipants": 0,
		    "isEditablePriorToSale": true,
		    "unitsType": "pieces",
		    "quantityLabel": "Pieces",
		    "quantityUnitLabel": "pcs",
		    "discountLabel": "Discount",
		    "discountUnitLabel": "%"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var puzzleModel = PuzzleModel()
		puzzleModel.deserialize(json)

		XCTAssertEqual(puzzleModel.id, 1)
		XCTAssertEqual(puzzleModel.itemGuid, "item_guid")
		XCTAssertEqual(puzzleModel.name, "Puzzle Item")
		XCTAssertEqual(puzzleModel.status, "available")
		XCTAssertEqual(puzzleModel.statusId, 2)
		XCTAssertEqual(puzzleModel.categoryId, 3)
		XCTAssertEqual(puzzleModel.categoryName, "Puzzles")
		XCTAssertEqual(puzzleModel.itemType, "puzzle")
		XCTAssertEqual(puzzleModel.isDirectPurchaseItem, true)
		XCTAssertEqual(puzzleModel.isLive, false)
		XCTAssertEqual(puzzleModel.isTicket, false)
		XCTAssertEqual(puzzleModel.isPuzzle, true)
		XCTAssertEqual(puzzleModel.isAppeal, false)
		XCTAssertEqual(puzzleModel.availableForPreSale, false)
		XCTAssertEqual(puzzleModel.buyNowPrice, 20.0)
		XCTAssertEqual(puzzleModel.startingPrice, 10.0)
		XCTAssertEqual(puzzleModel.bidIncrement, 1.0)
		XCTAssertEqual(puzzleModel.minimumBidAmount, 11.0)
		XCTAssertEqual(puzzleModel.description, "A challenging puzzle.")
		XCTAssertEqual(puzzleModel.donor, "Puzzle Company")
		XCTAssertEqual(puzzleModel.notables, "Notable features of the puzzle.")
		XCTAssertEqual(puzzleModel.value, 25.0)
		XCTAssertEqual(puzzleModel.currentPrice, 15.0)
		XCTAssertEqual(puzzleModel.isRedeemable, true)
		XCTAssertEqual(puzzleModel.highestBid, 17.0)
		XCTAssertEqual(puzzleModel.highestProxyBid, 18.0)
		XCTAssertEqual(puzzleModel.bidCount, 3)
		XCTAssertEqual(puzzleModel.winnerId, 4)
		XCTAssertEqual(puzzleModel.winningBidderName, "Jane Doe")
		XCTAssertEqual(puzzleModel.redemptionInstructions, "Contact support.")
		XCTAssertEqual(puzzleModel.imageUrl, "https://example.com/puzzle.jpg")
		XCTAssertEqual(puzzleModel.images?.count, 1)
		XCTAssertEqual(puzzleModel.videoEmbedCode, "video_code")
		XCTAssertEqual(puzzleModel.key, "puzzle_key")
		XCTAssertEqual(puzzleModel.itemCode, "PZ123")
		XCTAssertEqual(puzzleModel.quantitySold, 5)
		XCTAssertEqual(puzzleModel.puzzlePiecesSold, 10)
		XCTAssertEqual(puzzleModel.disableMobileBidding, false)
		XCTAssertEqual(puzzleModel.hasInventory, true)
		XCTAssertEqual(puzzleModel.inventoryRemaining, 20)
		XCTAssertEqual(puzzleModel.inventoryTotal, 25)
		XCTAssertEqual(puzzleModel.timerStartTime, 0)
		XCTAssertEqual(puzzleModel.timerEndTime, 0)
		XCTAssertEqual(puzzleModel.timerEndTimeGMT, "2023-01-01T00:00:00Z")
		XCTAssertEqual(puzzleModel.timerRemaining, 0)
		XCTAssertEqual(puzzleModel.isHidden, false)
		XCTAssertEqual(puzzleModel.isBackendOnly, false)
		XCTAssertEqual(puzzleModel.showValue, true)
		XCTAssertEqual(puzzleModel.isBidpadOnly, false)
		XCTAssertEqual(puzzleModel.ticketQuantity, 0)
		XCTAssertEqual(puzzleModel.valueReceived, 0.0)
		XCTAssertEqual(puzzleModel.admits, 0)
		XCTAssertEqual(puzzleModel.ticketDeferredPaymentAllowed, false)
		XCTAssertEqual(puzzleModel.ticketLimit, 0)
		XCTAssertEqual(puzzleModel.surcharge, 0.0)
		XCTAssertEqual(puzzleModel.surchargeName, "")
		XCTAssertEqual(puzzleModel.ticketInstructions, "")
		XCTAssertEqual(puzzleModel.ticketPaymentInstructions, "")
		XCTAssertEqual(puzzleModel.hideSales, false)
		XCTAssertEqual(puzzleModel.isFeatured, false)
		XCTAssertEqual(puzzleModel.isAvailableCheckin, false)
		XCTAssertEqual(puzzleModel.valueAsPriceless, false)
		XCTAssertEqual(puzzleModel.puzzlePiecesCount, 1000)
		XCTAssertEqual(puzzleModel.showPurchaserNames, false)
		XCTAssertEqual(puzzleModel.instructionsPuzzle, "Some instructions")
		XCTAssertEqual(puzzleModel.isPromoted, true)
		XCTAssertEqual(puzzleModel.reservePrice, 0.0)
		XCTAssertEqual(puzzleModel.isPassed, false)
		XCTAssertEqual(puzzleModel.hideFromPurchases, false)
		XCTAssertEqual(puzzleModel.customFieldValues?.count, 0)
		XCTAssertEqual(puzzleModel.customQuantitiesThreshold?.count, 0)
		XCTAssertEqual(puzzleModel.quantityParticipants, 0)
		XCTAssertEqual(puzzleModel.isEditablePriorToSale, true)
		XCTAssertEqual(puzzleModel.unitsType, "pieces")
		XCTAssertEqual(puzzleModel.quantityLabel, "Pieces")
		XCTAssertEqual(puzzleModel.quantityUnitLabel, "pcs")
		XCTAssertEqual(puzzleModel.discountLabel, "Discount")
		XCTAssertEqual(puzzleModel.discountUnitLabel, "%")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var puzzleModel = PuzzleModel()
		puzzleModel.deserialize(json)

		XCTAssertNil(puzzleModel.id)
		XCTAssertNil(puzzleModel.itemGuid)
		XCTAssertNil(puzzleModel.name)
		XCTAssertNil(puzzleModel.status)
		XCTAssertNil(puzzleModel.statusId)
		XCTAssertNil(puzzleModel.categoryId)
		XCTAssertNil(puzzleModel.categoryName)
		XCTAssertNil(puzzleModel.itemType)
		XCTAssertNil(puzzleModel.isDirectPurchaseItem)
		XCTAssertNil(puzzleModel.isLive)
		XCTAssertNil(puzzleModel.isTicket)
		XCTAssertNil(puzzleModel.isPuzzle)
		XCTAssertNil(puzzleModel.isAppeal)
		XCTAssertNil(puzzleModel.availableForPreSale)
		XCTAssertNil(puzzleModel.buyNowPrice)
		XCTAssertNil(puzzleModel.startingPrice)
		XCTAssertNil(puzzleModel.bidIncrement)
		XCTAssertNil(puzzleModel.minimumBidAmount)
		XCTAssertNil(puzzleModel.description)
		XCTAssertNil(puzzleModel.donor)
		XCTAssertNil(puzzleModel.notables)
		XCTAssertNil(puzzleModel.value)
		XCTAssertNil(puzzleModel.currentPrice)
		XCTAssertNil(puzzleModel.isRedeemable)
		XCTAssertNil(puzzleModel.highestBid)
		XCTAssertNil(puzzleModel.highestProxyBid)
		XCTAssertNil(puzzleModel.bidCount)
		XCTAssertNil(puzzleModel.winnerId)
		XCTAssertNil(puzzleModel.winningBidderName)
		XCTAssertNil(puzzleModel.redemptionInstructions)
		XCTAssertNil(puzzleModel.imageUrl)
		XCTAssertNil(puzzleModel.videoEmbedCode)
		XCTAssertNil(puzzleModel.key)
		XCTAssertNil(puzzleModel.itemCode)
		XCTAssertNil(puzzleModel.quantitySold)
		XCTAssertNil(puzzleModel.puzzlePiecesSold)
		XCTAssertNil(puzzleModel.disableMobileBidding)
		XCTAssertNil(puzzleModel.hasInventory)
		XCTAssertNil(puzzleModel.inventoryRemaining)
		XCTAssertNil(puzzleModel.inventoryTotal)
		XCTAssertNil(puzzleModel.timerStartTime)
		XCTAssertNil(puzzleModel.timerEndTime)
		XCTAssertNil(puzzleModel.timerEndTimeGMT)
		XCTAssertNil(puzzleModel.timerRemaining)
		XCTAssertNil(puzzleModel.isHidden)
		XCTAssertNil(puzzleModel.isBackendOnly)
		XCTAssertNil(puzzleModel.showValue)
		XCTAssertNil(puzzleModel.isBidpadOnly)
		XCTAssertNil(puzzleModel.ticketQuantity)
		XCTAssertNil(puzzleModel.valueReceived)
		XCTAssertNil(puzzleModel.admits)
		XCTAssertNil(puzzleModel.ticketDeferredPaymentAllowed)
		XCTAssertNil(puzzleModel.ticketLimit)
		XCTAssertNil(puzzleModel.surcharge)
		XCTAssertNil(puzzleModel.surchargeName)
		XCTAssertNil(puzzleModel.ticketInstructions)
		XCTAssertNil(puzzleModel.ticketPaymentInstructions)
		XCTAssertNil(puzzleModel.hideSales)
		XCTAssertNil(puzzleModel.isFeatured)
		XCTAssertNil(puzzleModel.isAvailableCheckin)
		XCTAssertNil(puzzleModel.valueAsPriceless)
		XCTAssertNil(puzzleModel.puzzlePiecesCount)
		XCTAssertNil(puzzleModel.showPurchaserNames)
		XCTAssertNil(puzzleModel.instructionsPuzzle)
		XCTAssertNil(puzzleModel.isPromoted)
		XCTAssertNil(puzzleModel.reservePrice)
		XCTAssertNil(puzzleModel.isPassed)
		XCTAssertNil(puzzleModel.hideFromPurchases)
		XCTAssertTrue(puzzleModel.customFieldValues?.isEmpty ?? true)
		XCTAssertTrue(puzzleModel.customQuantitiesThreshold?.isEmpty ?? true)
		XCTAssertNil(puzzleModel.quantityParticipants)
		XCTAssertNil(puzzleModel.isEditablePriorToSale)
		XCTAssertNil(puzzleModel.unitsType)
		XCTAssertNil(puzzleModel.quantityLabel)
		XCTAssertNil(puzzleModel.quantityUnitLabel)
		XCTAssertNil(puzzleModel.discountLabel)
		XCTAssertNil(puzzleModel.discountUnitLabel)
		XCTAssertTrue(puzzleModel.images?.isEmpty ?? true)
	}
}
