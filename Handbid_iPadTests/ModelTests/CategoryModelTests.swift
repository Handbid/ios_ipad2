// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class CategoryModelTests: XCTestCase {
	func testCategoryModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "name": "Electronics",
		    "auctionId": 123,
		    "items": [
		        {
		            "id": 1,
		            "itemGuid": "item_guid_1",
		            "name": "Laptop",
		            "status": "available",
		            "categoryId": 1,
		            "categoryName": "Electronics",
		            "itemType": "electronic",
		            "isDirectPurchaseItem": false,
		            "isLive": true,
		            "isTicket": false,
		            "isPuzzle": false,
		            "isAppeal": false,
		            "availableForPreSale": true,
		            "buyNowPrice": 1000.0,
		            "startingPrice": 500.0,
		            "bidIncrement": 50.0,
		            "minimumBidAmount": 550.0,
		            "description": "A high-end laptop.",
		            "donor": "Company",
		            "notables": "Some notable features.",
		            "value": 1500.0,
		            "currentPrice": 1050.0,
		            "isRedeemable": true,
		            "highestBid": 1100.0,
		            "highestProxyBid": 1150.0,
		            "bidCount": 5,
		            "winnerId": 1,
		            "winningBidderName": "John Doe",
		            "redemptionInstructions": "Contact us.",
		            "imageUrl": "https://example.com/image.jpg",
		            "videoEmbedCode": "embed_code",
		            "key": "laptop_key",
		            "itemCode": "LT123",
		            "quantitySold": 10,
		            "puzzlePiecesSold": 0,
		            "disableMobileBidding": false,
		            "hasInventory": true,
		            "inventoryRemaining": 5,
		            "inventoryTotal": 15,
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
		            "puzzlePiecesCount": 0,
		            "showPurchaserNames": false,
		            "instructionsPuzzle": "",
		            "isPromoted": false,
		            "reservePrice": 0.0,
		            "isPassed": false,
		            "hideFromPurchases": false,
		            "customFieldValues": [],
		            "customQuantitiesThreshold": [],
		            "quantityParticipants": 0,
		            "isEditablePriorToSale": false,
		            "unitsType": "",
		            "quantityLabel": "",
		            "quantityUnitLabel": "",
		            "discountLabel": "",
		            "discountUnitLabel": ""
		        }
		    ]
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var categoryModel = CategoryModel()
		categoryModel.deserialize(json)

		XCTAssertEqual(categoryModel.id, 1)
		XCTAssertEqual(categoryModel.name, "Electronics")
		XCTAssertEqual(categoryModel.auctionId, 123)
		XCTAssertEqual(categoryModel.items?.count, 1)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var categoryModel = CategoryModel()
		categoryModel.deserialize(json)

		XCTAssertNil(categoryModel.id)
		XCTAssertNil(categoryModel.name)
		XCTAssertNil(categoryModel.auctionId)
		XCTAssertTrue(categoryModel.items?.isEmpty ?? true)
	}
}
