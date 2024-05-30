// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class OrganizationImageModelTests: XCTestCase {
	func testOrganizationImageModelDeserialization() {
		let jsonString = """
		{
		    "organizationImageId": 1,
		    "organizationImageGuid": "image_guid",
		    "organizationImageCaption": "A caption",
		    "organizationImageFileName": "image.jpg",
		    "organizationImageUrl": "https://example.com/image.jpg"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var organizationImageModel = OrganizationImageModel()
		organizationImageModel.deserialize(json)

		XCTAssertEqual(organizationImageModel.imageId, 1)
		XCTAssertEqual(organizationImageModel.imageGuid, "image_guid")
		XCTAssertEqual(organizationImageModel.caption, "A caption")
		XCTAssertEqual(organizationImageModel.fileName, "image.jpg")
		XCTAssertEqual(organizationImageModel.imageUrl, "https://example.com/image.jpg")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var organizationImageModel = OrganizationImageModel()
		organizationImageModel.deserialize(json)

		XCTAssertNil(organizationImageModel.imageId)
		XCTAssertNil(organizationImageModel.imageGuid)
		XCTAssertNil(organizationImageModel.caption)
		XCTAssertNil(organizationImageModel.fileName)
		XCTAssertNil(organizationImageModel.imageUrl)
	}
}
