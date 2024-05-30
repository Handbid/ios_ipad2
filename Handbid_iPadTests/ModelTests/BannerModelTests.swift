// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class BannerModelTests: XCTestCase {
	func testBannerDeserialization() {
		let jsonString = """
		{
		    "imageUrl": "https://example.com/image.jpg",
		    "link": "https://example.com"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var banner = Banner()
		banner.deserialize(json)

		XCTAssertEqual(banner.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(banner.link, "https://example.com")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var banner = Banner()
		banner.deserialize(json)

		XCTAssertNil(banner.imageUrl)
		XCTAssertNil(banner.link)
	}
}
