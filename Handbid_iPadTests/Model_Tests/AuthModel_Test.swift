// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

final class AuthModel_Test: XCTestCase {
	func testAuthModelDataInit() {
		let jsonData: [String: Any] = [
			"data.token": "sampleToken",
			"data.access_token": "sampleAccessToken",
			"data.expires_in": 3600,
			"data.token_type": "Bearer",
			"data.refresh_token": "sampleRefreshToken",
			"data.currentPaddleNumber": "12345",
			"data.username": "sampleUsername",
			"data.identity": 1,
			"data.guid": "sampleGuid",
			"data.role": "sampleRole",
			"data.authenticatedTwice": true,
			"data.phoneLastFourDigit": "6789",
			"data.countryCode": "US",
			"data.isPasswordExpired": false,
			"data.oneTimePassword": 1234,
		]

		let authModel = AuthModel(json: jsonData)

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
