// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

final class AuthModel_Test: XCTestCase {
	func testAuthModelDeserialization() {
		let jsonString = """
		{
		    "data": {
		        "token": "sampleToken",
		        "access_token": "sampleAccessToken",
		        "expires_in": 3600,
		        "token_type": "Bearer",
		        "refresh_token": "sampleRefreshToken",
		        "currentPaddleNumber": "12345",
		        "username": "sampleUsername",
		        "identity": 1,
		        "guid": "sampleGuid",
		        "role": "sampleRole",
		        "authenticatedTwice": true,
		        "phoneLastFourDigit": "6789",
		        "countryCode": "US",
		        "isPasswordExpired": false,
		        "oneTimePassword": 1234
		    }
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var authModel = AuthModel()
		authModel.deserialize(json)

		XCTAssertNotNil(authModel)
		XCTAssertEqual(authModel.token, "sampleToken")
		XCTAssertEqual(authModel.accessToken, "sampleAccessToken")
		XCTAssertEqual(authModel.expiresIn, 3600)
		XCTAssertEqual(authModel.tokenType, "Bearer")
		XCTAssertEqual(authModel.refreshToken, "sampleRefreshToken")
		XCTAssertEqual(authModel.currentPaddleNumber, "12345")
		XCTAssertEqual(authModel.username, "sampleUsername")
		XCTAssertEqual(authModel.identity, 1)
		XCTAssertEqual(authModel.guid, "sampleGuid")
		XCTAssertEqual(authModel.role, "sampleRole")
		XCTAssertEqual(authModel.authenticatedTwice, true)
		XCTAssertEqual(authModel.phoneLastFourDigit, "6789")
		XCTAssertEqual(authModel.countryCode, "US")
		XCTAssertEqual(authModel.isPasswordExpired, false)
		XCTAssertEqual(authModel.oneTimePassword, 1234)

		XCTAssertNotNil(authModel.token)
		XCTAssertNotNil(authModel.accessToken)
		XCTAssertNotNil(authModel.expiresIn)
		XCTAssertNotNil(authModel.tokenType)
		XCTAssertNotNil(authModel.refreshToken)
		XCTAssertNotNil(authModel.currentPaddleNumber)
		XCTAssertNotNil(authModel.username)
		XCTAssertNotNil(authModel.identity)
		XCTAssertNotNil(authModel.guid)
		XCTAssertNotNil(authModel.role)
		XCTAssertNotNil(authModel.authenticatedTwice)
		XCTAssertNotNil(authModel.phoneLastFourDigit)
		XCTAssertNotNil(authModel.countryCode)
		XCTAssertNotNil(authModel.isPasswordExpired)
		XCTAssertNotNil(authModel.oneTimePassword)
	}
}
