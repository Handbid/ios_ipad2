// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class AuctionModelTests: XCTestCase {
	func testAuctionModelDeserialization() {
		let jsonString = """
		{
		    "auctionGuid": "123",
		    "id": 456,
		    "key": "auctionKey",
		    "imageUrl": "https://example.com/image.jpg",
		    "name": "Auction Name",
		    "status": "active",
		    "timeZone": "PST",
		    "startTime": 1622517800,
		    "endTime": 1625109800,
		    "hasExtendedBidding": true,
		    "extendedBiddingTimeoutInMinutes": 15,
		    "requireCreditCard": true,
		    "spendingThreshold": 1000.0,
		    "description": "Auction description",
		    "currencyCode": "USD",
		    "totalBidders": 100,
		    "totalItems": 50,
		    "vanityAddress": "auction",
		    "taxRate": 7.5,
		    "lat": "34.0522",
		    "lng": "-118.2437",
		    "goal": 50000.0
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var auctionModel = AuctionModel()
		auctionModel.deserialize(json)

		XCTAssertEqual(auctionModel.id, "123")
		XCTAssertEqual(auctionModel.identity, 456)
		XCTAssertEqual(auctionModel.key, "auctionKey")
		XCTAssertEqual(auctionModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(auctionModel.name, "Auction Name")
		XCTAssertEqual(auctionModel.status, "active")
		XCTAssertEqual(auctionModel.timeZone, "PST")
		XCTAssertEqual(auctionModel.startTime, 1_622_517_800)
		XCTAssertEqual(auctionModel.endTime, 1_625_109_800)
		XCTAssertEqual(auctionModel.hasExtendedBidding, true)
		XCTAssertEqual(auctionModel.extendedBiddingTimeoutInMinutes, 15)
		XCTAssertEqual(auctionModel.requireCreditCard, true)
		XCTAssertEqual(auctionModel.spendingThreshold, 1000.0)
		XCTAssertEqual(auctionModel.auctionDescription, "Auction description")
		XCTAssertEqual(auctionModel.currencyCode, "USD")
		XCTAssertEqual(auctionModel.totalBidders, 100)
		XCTAssertEqual(auctionModel.totalItems, 50)
		XCTAssertEqual(auctionModel.vanityAddress, "auction")
		XCTAssertEqual(auctionModel.taxRate, 7.5)
		XCTAssertEqual(auctionModel.lat, "34.0522")
		XCTAssertEqual(auctionModel.lng, "-118.2437")
		XCTAssertEqual(auctionModel.goal, 50000.0)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var auctionModel = AuctionModel()
		auctionModel.deserialize(json)

		XCTAssertNil(auctionModel.identity)
		XCTAssertNil(auctionModel.key)
		XCTAssertNil(auctionModel.imageUrl)
		XCTAssertNil(auctionModel.name)
		XCTAssertNil(auctionModel.status)
		XCTAssertNil(auctionModel.timeZone)
		XCTAssertNil(auctionModel.startTime)
		XCTAssertNil(auctionModel.endTime)
		XCTAssertNil(auctionModel.hasExtendedBidding)
		XCTAssertNil(auctionModel.extendedBiddingTimeoutInMinutes)
		XCTAssertNil(auctionModel.requireCreditCard)
		XCTAssertNil(auctionModel.spendingThreshold)
		XCTAssertNil(auctionModel.auctionDescription)
		XCTAssertNil(auctionModel.currencyCode)
		XCTAssertNil(auctionModel.totalBidders)
		XCTAssertNil(auctionModel.totalItems)
		XCTAssertNil(auctionModel.vanityAddress)
		XCTAssertNil(auctionModel.taxRate)
		XCTAssertNil(auctionModel.lat)
		XCTAssertNil(auctionModel.lng)
		XCTAssertNil(auctionModel.goal)
	}
}

extension AuctionModel {
	static func mockAuction() -> AuctionModel {
		AuctionModel(id: "12345", name: "Test Auction", status: "open")
	}
}
