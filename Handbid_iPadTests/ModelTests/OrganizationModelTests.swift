// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class OrganizationModelTests: XCTestCase {
	func testOrganizationModelDeserialization() {
		let jsonString = """
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
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var organizationModel = OrganizationModel()
		organizationModel.deserialize(json)

		XCTAssertEqual(organizationModel.id, "org_guid")
		XCTAssertEqual(organizationModel.identity, 1)
		XCTAssertEqual(organizationModel.key, "org_key")
		XCTAssertEqual(organizationModel.name, "Test Organization")
		XCTAssertEqual(organizationModel.organizationDescription, "An organization description")
		XCTAssertEqual(organizationModel.organizationPhone, "123-456-7890")
		XCTAssertEqual(organizationModel.ein, "123456789")
		XCTAssertEqual(organizationModel.contactName, "John Doe")
		XCTAssertEqual(organizationModel.email, "contact@example.com")
		XCTAssertEqual(organizationModel.website, "https://example.com")
		XCTAssertEqual(organizationModel.isPublic, 1)
		XCTAssertEqual(organizationModel.totalAuctions, 10)
		XCTAssertEqual(organizationModel.activeAuctions, 2)
		XCTAssertEqual(organizationModel.logo, "https://example.com/logo.jpg")
		XCTAssertEqual(organizationModel.banner, "https://example.com/banner.jpg")
		XCTAssertEqual(organizationModel.socialFacebook, "https://facebook.com/org")
		XCTAssertEqual(organizationModel.socialGoogle, "https://plus.google.com/org")
		XCTAssertEqual(organizationModel.socialTwitter, "https://twitter.com/org")
		XCTAssertEqual(organizationModel.socialPinterest, "https://pinterest.com/org")
		XCTAssertEqual(organizationModel.socialLinkedin, "https://linkedin.com/org")
		XCTAssertEqual(organizationModel.businessType, "Non-profit")
		XCTAssertEqual(organizationModel.classification, "Education")
		XCTAssertEqual(organizationModel.provinceCode, "CA")
		XCTAssertEqual(organizationModel.organizationAddressStreet1, "123 Main St")
		XCTAssertEqual(organizationModel.organizationAddressStreet2, "Suite 200")
		XCTAssertEqual(organizationModel.organizationAddressCity, "Anytown")
		XCTAssertEqual(organizationModel.organizationAddressPostalCode, "12345")
		XCTAssertEqual(organizationModel.organizationAddressProvince, "CA")
		XCTAssertEqual(organizationModel.organizationAddressCountry, "USA")
		XCTAssertEqual(organizationModel.organizationAddressProvinceId, 1)
		XCTAssertEqual(organizationModel.organizationAddressCountryId, 1)
		XCTAssertNotNil(organizationModel.organizationImages)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var organizationModel = OrganizationModel()
		organizationModel.deserialize(json)

		XCTAssertNil(organizationModel.identity)
		XCTAssertNil(organizationModel.organizationGuid)
		XCTAssertNil(organizationModel.key)
		XCTAssertNil(organizationModel.name)
		XCTAssertNil(organizationModel.organizationDescription)
		XCTAssertNil(organizationModel.organizationPhone)
		XCTAssertNil(organizationModel.ein)
		XCTAssertNil(organizationModel.contactName)
		XCTAssertNil(organizationModel.email)
		XCTAssertNil(organizationModel.website)
		XCTAssertNil(organizationModel.isPublic)
		XCTAssertNil(organizationModel.totalAuctions)
		XCTAssertNil(organizationModel.activeAuctions)
		XCTAssertNil(organizationModel.logo)
		XCTAssertNil(organizationModel.banner)
		XCTAssertNil(organizationModel.socialFacebook)
		XCTAssertNil(organizationModel.socialGoogle)
		XCTAssertNil(organizationModel.socialTwitter)
		XCTAssertNil(organizationModel.socialPinterest)
		XCTAssertNil(organizationModel.socialLinkedin)
		XCTAssertNil(organizationModel.businessType)
		XCTAssertNil(organizationModel.classification)
		XCTAssertNil(organizationModel.provinceCode)
		XCTAssertNil(organizationModel.organizationAddressStreet1)
		XCTAssertNil(organizationModel.organizationAddressStreet2)
		XCTAssertNil(organizationModel.organizationAddressCity)
		XCTAssertNil(organizationModel.organizationAddressPostalCode)
		XCTAssertNil(organizationModel.organizationAddressProvince)
		XCTAssertNil(organizationModel.organizationAddressCountry)
		XCTAssertNil(organizationModel.organizationAddressProvinceId)
		XCTAssertNil(organizationModel.organizationAddressCountryId)
		XCTAssertNil(organizationModel.organizationImages)
	}
}
