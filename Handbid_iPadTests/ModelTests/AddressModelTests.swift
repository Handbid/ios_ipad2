// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class AddressModelTests: XCTestCase {
	func testAddressModelDeserialization() {
		let jsonString = """
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
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var addressModel = AddressModel()
		addressModel.deserialize(json)

		XCTAssertEqual(addressModel.street, "123 Main St")
		XCTAssertEqual(addressModel.street1, "Apt 4B")
		XCTAssertEqual(addressModel.street2, "Suite 5")
		XCTAssertEqual(addressModel.city, "Anytown")
		XCTAssertEqual(addressModel.province, "CA")
		XCTAssertEqual(addressModel.state, "California")
		XCTAssertEqual(addressModel.postalCode, "12345")
		XCTAssertEqual(addressModel.country, "USA")
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var addressModel = AddressModel()
		addressModel.deserialize(json)

		XCTAssertNil(addressModel.street)
		XCTAssertNil(addressModel.street1)
		XCTAssertNil(addressModel.street2)
		XCTAssertNil(addressModel.city)
		XCTAssertNil(addressModel.province)
		XCTAssertNil(addressModel.state)
		XCTAssertNil(addressModel.postalCode)
		XCTAssertNil(addressModel.country)
	}
}
