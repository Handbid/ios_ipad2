// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class CreditCardModelTests: XCTestCase {
	func testCreditCardModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "creditCardsGuid": "card_guid",
		    "creditCardHandle": "handle",
		    "creditCardToken": "token",
		    "stripeId": "stripe_id",
		    "lastFour": "1234",
		    "cardType": "Visa",
		    "nameOnCard": "John Doe",
		    "expMonth": 12,
		    "expYear": 2024,
		    "isActiveCard": 1,
		    "ccAddressStreet1": "123 Main St",
		    "ccAddressStreet2": "Suite 100",
		    "ccAddressCity": "Anytown",
		    "ccAddressProvinceId": 1,
		    "ccAddressPostalCode": "12345",
		    "ccAddressCountryId": 1,
		    "gatewayId": 2,
		    "tokenizedCard": "tokenized_card"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var creditCardModel = CreditCardModel()
		creditCardModel.deserialize(json)

		XCTAssertEqual(creditCardModel.id, 1)
		XCTAssertEqual(creditCardModel.creditCardsGuid, "card_guid")
		XCTAssertEqual(creditCardModel.creditCardHandle, "handle")
		XCTAssertEqual(creditCardModel.creditCardToken, "token")
		XCTAssertEqual(creditCardModel.stripeId, "stripe_id")
		XCTAssertEqual(creditCardModel.lastFour, "1234")
		XCTAssertEqual(creditCardModel.cardType, "Visa")
		XCTAssertEqual(creditCardModel.nameOnCard, "John Doe")
		XCTAssertEqual(creditCardModel.expMonth, 12)
		XCTAssertEqual(creditCardModel.expYear, 2024)
		XCTAssertEqual(creditCardModel.isActiveCard, 1)
		XCTAssertEqual(creditCardModel.ccAddressStreet1, "123 Main St")
		XCTAssertEqual(creditCardModel.ccAddressStreet2, "Suite 100")
		XCTAssertEqual(creditCardModel.ccAddressCity, "Anytown")
		XCTAssertEqual(creditCardModel.ccAddressProvinceId, 1)
		XCTAssertEqual(creditCardModel.ccAddressPostalCode, "12345")
		XCTAssertEqual(creditCardModel.ccAddressCountryId, 1)
		XCTAssertEqual(creditCardModel.gatewayId, 2)
		XCTAssertEqual(creditCardModel.tokenizedCard, "tokenized_card")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var creditCardModel = CreditCardModel()
		creditCardModel.deserialize(json)

		XCTAssertEqual(creditCardModel.id, 0)
		XCTAssertNil(creditCardModel.creditCardsGuid)
		XCTAssertNil(creditCardModel.creditCardHandle)
		XCTAssertNil(creditCardModel.creditCardToken)
		XCTAssertNil(creditCardModel.stripeId)
		XCTAssertNil(creditCardModel.lastFour)
		XCTAssertNil(creditCardModel.cardType)
		XCTAssertNil(creditCardModel.nameOnCard)
		XCTAssertNil(creditCardModel.expMonth)
		XCTAssertNil(creditCardModel.expYear)
		XCTAssertNil(creditCardModel.isActiveCard)
		XCTAssertNil(creditCardModel.ccAddressStreet1)
		XCTAssertNil(creditCardModel.ccAddressStreet2)
		XCTAssertNil(creditCardModel.ccAddressCity)
		XCTAssertNil(creditCardModel.ccAddressProvinceId)
		XCTAssertNil(creditCardModel.ccAddressPostalCode)
		XCTAssertNil(creditCardModel.ccAddressCountryId)
		XCTAssertNil(creditCardModel.gatewayId)
		XCTAssertNil(creditCardModel.tokenizedCard)
	}
}
