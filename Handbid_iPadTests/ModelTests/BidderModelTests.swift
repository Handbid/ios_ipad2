// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class BidderModelTests: XCTestCase {
	func testBidderModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "pin": 1234,
		    "usersGuid": "test_users_guid",
		    "stripeId": "test_stripe_id",
		    "name": "Test Name",
		    "alias": "Test Alias",
		    "currentPaddleNumber": "5678",
		    "currentPlacement": "1st",
		    "placementLabel": "First",
		    "firstName": "John",
		    "lastName": "Doe",
		    "email": "john.doe@example.com",
		    "requestDataUpdate": true,
		    "userPhone": "123-456-7890",
		    "userCellPhone": "098-765-4321",
		    "isPrivate": false,
		    "shippingAddress": "123 Main St",
		    "userAddressCountryId": 99,
		    "countryCode": "US",
		    "currency": "USD",
		    "timeZone": "PST",
		    "imageUrl": "https://example.com/image.jpg",
		    "isCheckinAgent": true,
		    "canCloseAuction": true,
		    "canSendBroadcast": true,
		    "canManageItems": true,
		    "addresses": [
		        {
		            "street": "123 Main St",
		            "street1": "Apt 4B",
		            "street2": "Suite 5",
		            "city": "Anytown",
		            "province": "CA",
		            "state": "California",
		            "postalCode": "12345",
		            "country": "USA"
		        }
		    ],
		    "organization": [
		        {
		            "organizationGuid": "org_guid",
		            "id": 1,
		            "key": "org_key",
		            "name": "Test Organization",
		            "description": "An organization description",
		            "organizationPhone": "123-456-7890",
		            "ein": "123456789",
		            "contactName": "John Doe",
		            "email": "contact@example.com",
		            "website": "https://example.com",
		            "public": 1,
		            "totalAuctions": 10,
		            "activeAuctions": 2,
		            "logo": "https://example.com/logo.jpg",
		            "banner": "https://example.com/banner.jpg",
		            "socialFacebook": "https://facebook.com/org",
		            "socialGoogle": "https://plus.google.com/org",
		            "socialTwitter": "https://twitter.com/org",
		            "socialPinterest": "https://pinterest.com/org",
		            "socialLinkedin": "https://linkedin.com/org",
		            "businessType": "Non-profit",
		            "classification": "Education",
		            "provinceCode": "CA",
		            "organizationAddressStreet1": "123 Main St",
		            "organizationAddressStreet2": "Suite 200",
		            "organizationAddressCity": "Anytown",
		            "organizationAddressPostalCode": "12345",
		            "organizationAddressProvince": "CA",
		            "organizationAddressCountry": "USA",
		            "organizationAddressProvinceId": 1,
		            "organizationAddressCountryId": 1,
		            "organizationImages": [
		                {
		                    "organizationImageId": 1,
		                    "organizationImageGuid": "image_guid",
		                    "organizationImageCaption": "A caption",
		                    "organizationImageFileName": "image.jpg",
		                    "organizationImageUrl": "https://example.com/image.jpg"
		                }
		            ]
		        }
		    ],
		    "creditCards": [
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
		    ]
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var bidderModel = BidderModel()
		bidderModel.deserialize(json)

		XCTAssertEqual(bidderModel.id, 1)
		XCTAssertEqual(bidderModel.pin, 1234)
		XCTAssertEqual(bidderModel.usersGuid, "test_users_guid")
		XCTAssertEqual(bidderModel.stripeId, "test_stripe_id")
		XCTAssertEqual(bidderModel.name, "Test Name")
		XCTAssertEqual(bidderModel.alias, "Test Alias")
		XCTAssertEqual(bidderModel.currentPaddleNumber, "5678")
		XCTAssertEqual(bidderModel.currentPlacement, "1st")
		XCTAssertEqual(bidderModel.placementLabel, "First")
		XCTAssertEqual(bidderModel.firstName, "John")
		XCTAssertEqual(bidderModel.lastName, "Doe")
		XCTAssertEqual(bidderModel.email, "john.doe@example.com")
		XCTAssertEqual(bidderModel.requestDataUpdate, true)
		XCTAssertEqual(bidderModel.userPhone, "123-456-7890")
		XCTAssertEqual(bidderModel.userCellPhone, "098-765-4321")
		XCTAssertEqual(bidderModel.isPrivate, false)
		XCTAssertEqual(bidderModel.shippingAddress, "123 Main St")
		XCTAssertEqual(bidderModel.userAddressCountryId, 99)
		XCTAssertEqual(bidderModel.countryCode, "US")
		XCTAssertEqual(bidderModel.currency, "USD")
		XCTAssertEqual(bidderModel.timeZone, "PST")
		XCTAssertEqual(bidderModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(bidderModel.isCheckinAgent, true)
		XCTAssertEqual(bidderModel.canCloseAuction, true)
		XCTAssertEqual(bidderModel.canSendBroadcast, true)
		XCTAssertEqual(bidderModel.canManageItems, true)
		XCTAssertEqual(bidderModel.addresses?.count, 1)
		XCTAssertEqual(bidderModel.organization?.count, 1)
		XCTAssertEqual(bidderModel.creditCards?.count, 1)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var bidderModel = BidderModel()
		bidderModel.deserialize(json)

		XCTAssertNil(bidderModel.id)
		XCTAssertNil(bidderModel.pin)
		XCTAssertNil(bidderModel.usersGuid)
		XCTAssertNil(bidderModel.stripeId)
		XCTAssertNil(bidderModel.name)
		XCTAssertNil(bidderModel.alias)
		XCTAssertNil(bidderModel.currentPaddleNumber)
		XCTAssertNil(bidderModel.currentPlacement)
		XCTAssertNil(bidderModel.placementLabel)
		XCTAssertNil(bidderModel.firstName)
		XCTAssertNil(bidderModel.lastName)
		XCTAssertNil(bidderModel.email)
		XCTAssertNil(bidderModel.requestDataUpdate)
		XCTAssertNil(bidderModel.userPhone)
		XCTAssertNil(bidderModel.userCellPhone)
		XCTAssertNil(bidderModel.isPrivate)
		XCTAssertNil(bidderModel.shippingAddress)
		XCTAssertNil(bidderModel.userAddressCountryId)
		XCTAssertNil(bidderModel.countryCode)
		XCTAssertNil(bidderModel.currency)
		XCTAssertNil(bidderModel.timeZone)
		XCTAssertNil(bidderModel.imageUrl)
		XCTAssertNil(bidderModel.isCheckinAgent)
		XCTAssertNil(bidderModel.canCloseAuction)
		XCTAssertNil(bidderModel.canSendBroadcast)
		XCTAssertNil(bidderModel.canManageItems)
		XCTAssertTrue(bidderModel.addresses?.isEmpty ?? true)
		XCTAssertTrue(bidderModel.organization?.isEmpty ?? true)
		XCTAssertTrue(bidderModel.creditCards?.isEmpty ?? true)
	}
}
