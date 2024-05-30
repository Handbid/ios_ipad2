// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class UserModelTests: XCTestCase {
	func testUserModelDeserialization() {
		let jsonString = """
		{
		    "usersGuid": "user_guid",
		    "id": 1,
		    "pin": 1234,
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

		var userModel = UserModel()
		userModel.deserialize(json)

		XCTAssertEqual(userModel.id, "user_guid")
		XCTAssertEqual(userModel.identity, 1)
		XCTAssertEqual(userModel.pin, 1234)
		XCTAssertEqual(userModel.usersGuid, "user_guid")
		XCTAssertEqual(userModel.stripeId, "test_stripe_id")
		XCTAssertEqual(userModel.name, "Test Name")
		XCTAssertEqual(userModel.alias, "Test Alias")
		XCTAssertEqual(userModel.currentPaddleNumber, "5678")
		XCTAssertEqual(userModel.currentPlacement, "1st")
		XCTAssertEqual(userModel.placementLabel, "First")
		XCTAssertEqual(userModel.firstName, "John")
		XCTAssertEqual(userModel.lastName, "Doe")
		XCTAssertEqual(userModel.email, "john.doe@example.com")
		XCTAssertEqual(userModel.requestDataUpdate, true)
		XCTAssertEqual(userModel.userPhone, "123-456-7890")
		XCTAssertEqual(userModel.userCellPhone, "098-765-4321")
		XCTAssertEqual(userModel.isPrivate, false)
		XCTAssertEqual(userModel.shippingAddress, "123 Main St")
		XCTAssertEqual(userModel.userAddressCountryId, 99)
		XCTAssertEqual(userModel.countryCode, "US")
		XCTAssertEqual(userModel.currency, "USD")
		XCTAssertEqual(userModel.timeZone, "PST")
		XCTAssertEqual(userModel.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(userModel.isCheckinAgent, true)
		XCTAssertEqual(userModel.canCloseAuction, true)
		XCTAssertEqual(userModel.canSendBroadcast, true)
		XCTAssertEqual(userModel.addresses?.count, 1)
		XCTAssertEqual(userModel.organization?.count, 1)
		XCTAssertEqual(userModel.creditCards?.count, 1)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var userModel = UserModel()
		userModel.deserialize(json)

		XCTAssertNil(userModel.identity)
		XCTAssertNil(userModel.pin)
		XCTAssertNil(userModel.usersGuid)
		XCTAssertNil(userModel.stripeId)
		XCTAssertNil(userModel.name)
		XCTAssertNil(userModel.alias)
		XCTAssertNil(userModel.currentPaddleNumber)
		XCTAssertNil(userModel.currentPlacement)
		XCTAssertNil(userModel.placementLabel)
		XCTAssertNil(userModel.firstName)
		XCTAssertNil(userModel.lastName)
		XCTAssertNil(userModel.email)
		XCTAssertNil(userModel.requestDataUpdate)
		XCTAssertNil(userModel.userPhone)
		XCTAssertNil(userModel.userCellPhone)
		XCTAssertNil(userModel.isPrivate)
		XCTAssertNil(userModel.shippingAddress)
		XCTAssertNil(userModel.userAddressCountryId)
		XCTAssertNil(userModel.countryCode)
		XCTAssertNil(userModel.currency)
		XCTAssertNil(userModel.timeZone)
		XCTAssertNil(userModel.imageUrl)
		XCTAssertNil(userModel.isCheckinAgent)
		XCTAssertNil(userModel.canCloseAuction)
		XCTAssertNil(userModel.canSendBroadcast)
		XCTAssertNil(userModel.canManageItems)
		XCTAssertTrue(userModel.addresses?.isEmpty ?? true)
		XCTAssertTrue(userModel.organization?.isEmpty ?? true)
		XCTAssertTrue(userModel.creditCards?.isEmpty ?? true)
	}
}
