// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class AboutModelTests: XCTestCase {
	func testAboutMeDeserialization() {
		let jsonString = """
		{
		    "banner": {
		        "imageUrl": "https://example.com/image.jpg",
		        "link": "https://example.com"
		    },
		    "images": ["image1.jpg", "image2.jpg"]
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var aboutModel = AboutModel()
		aboutModel.deserialize(json)

		XCTAssertNotNil(aboutModel.banner)
		XCTAssertEqual(aboutModel.banner?.imageUrl, "https://example.com/image.jpg")
		XCTAssertEqual(aboutModel.banner?.link, "https://example.com")
		XCTAssertEqual(aboutModel.images?.count, 2)
		XCTAssertEqual(aboutModel.images?.first, "image1.jpg")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var aboutModel = AboutModel()
		aboutModel.deserialize(json)

		XCTAssertNil(aboutModel.banner)
		XCTAssertNil(aboutModel.images)
	}
}
