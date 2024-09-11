// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import NetworkService
import XCTest

class CountryModelTests: XCTestCase {
	func testCountryDeserialization() {
		let jsonString = """
		{
		    "id": 1,
		    "name": "United States of America",
		    "countryCode": "US",
		    "phoneCode": "1"
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var countryModel = CountryModel()
		countryModel.deserialize(json)

		XCTAssertEqual(countryModel.id, 1)
		XCTAssertEqual(countryModel.name, "United States of America")
		XCTAssertEqual(countryModel.countryCode, "US")
		XCTAssertEqual(countryModel.phoneCode, "1")
	}
}
