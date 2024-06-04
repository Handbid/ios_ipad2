// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class LandingPageModelTests: XCTestCase {
	func testLandingPageModelDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "isPublished": true,
		    "loadingGearsUrl": "https://example.com/gears.gif"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var landingPageModel = LandingPageModel()
		landingPageModel.deserialize(json)

		XCTAssertEqual(landingPageModel.id, 1)
		XCTAssertEqual(landingPageModel.isPublished, true)
		XCTAssertEqual(landingPageModel.loadingGearsUrl, "https://example.com/gears.gif")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var landingPageModel = LandingPageModel()
		landingPageModel.deserialize(json)

		XCTAssertNil(landingPageModel.id)
		XCTAssertNil(landingPageModel.isPublished)
		XCTAssertNil(landingPageModel.loadingGearsUrl)
	}
}
