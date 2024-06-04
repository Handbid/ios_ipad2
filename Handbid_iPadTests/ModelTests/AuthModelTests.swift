// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class AuthModelTests: XCTestCase {
	func testAuthModelDeserialization() {
		let jsonString = """
		{
		    "data": {
		        "token": "test_token",
		        "access_token": "test_access_token",
		        "expires_in": 3600,
		        "token_type": "Bearer",
		        "refresh_token": "test_refresh_token",
		        "currentPaddleNumber": "1234",
		        "username": "test_user",
		        "identity": 5678,
		        "guid": "test_guid",
		        "role": "admin",
		        "authenticatedTwice": true,
		        "phoneLastFourDigit": "1234",
		        "countryCode": "US",
		        "isPasswordExpired": false,
		        "oneTimePassword": 123456
		    }
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var authModel = AuthModel()
		authModel.deserialize(json)

		XCTAssertEqual(authModel.token, "test_token")
		XCTAssertEqual(authModel.accessToken, "test_access_token")
		XCTAssertEqual(authModel.expiresIn, 3600)
		XCTAssertEqual(authModel.tokenType, "Bearer")
		XCTAssertEqual(authModel.refreshToken, "test_refresh_token")
		XCTAssertEqual(authModel.currentPaddleNumber, "1234")
		XCTAssertEqual(authModel.username, "test_user")
		XCTAssertEqual(authModel.identity, 5678)
		XCTAssertEqual(authModel.guid, "test_guid")
		XCTAssertEqual(authModel.role, "admin")
		XCTAssertEqual(authModel.authenticatedTwice, true)
		XCTAssertEqual(authModel.phoneLastFourDigit, "1234")
		XCTAssertEqual(authModel.countryCode, "US")
		XCTAssertEqual(authModel.isPasswordExpired, false)
		XCTAssertEqual(authModel.oneTimePassword, 123_456)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var authModel = AuthModel()
		authModel.deserialize(json)

		XCTAssertNil(authModel.token)
		XCTAssertNil(authModel.accessToken)
		XCTAssertNil(authModel.expiresIn)
		XCTAssertNil(authModel.tokenType)
		XCTAssertNil(authModel.refreshToken)
		XCTAssertNil(authModel.currentPaddleNumber)
		XCTAssertNil(authModel.username)
		XCTAssertNil(authModel.identity)
		XCTAssertNil(authModel.guid)
		XCTAssertNil(authModel.role)
		XCTAssertNil(authModel.authenticatedTwice)
		XCTAssertNil(authModel.phoneLastFourDigit)
		XCTAssertNil(authModel.countryCode)
		XCTAssertNil(authModel.isPasswordExpired)
		XCTAssertNil(authModel.oneTimePassword)
	}
}
