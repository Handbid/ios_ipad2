// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

class OrganizationAddressModelTests: XCTestCase {
	func testDeserialize() {
		var model = OrganizationAddressModel()
		let json = JSON(["organizationAddressStreet1": "Main Street",
		                 "organizationAddressCity": "Springfield"])!
		model.deserialize(json)

		XCTAssertEqual(model.street1, "Main Street")
		XCTAssertEqual(model.city, "Springfield")
	}
}
