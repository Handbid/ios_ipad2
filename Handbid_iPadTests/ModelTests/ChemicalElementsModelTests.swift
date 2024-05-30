// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import XCTest

@testable import Handbid_iPad

class ChemicalElementsModelTests: XCTestCase {
	func testChemicalElementsModelDeserialization() {
		let jsonString = """
		{
		    "lead": true,
		    "mercury": false,
		    "nickel": true,
		    "cadmium": false,
		    "arsenic": true,
		    "chromium": false
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var chemicalElementsModel = ChemicalElementsModel()
		chemicalElementsModel.deserialize(json)

		XCTAssertEqual(chemicalElementsModel.lead, true)
		XCTAssertEqual(chemicalElementsModel.mercury, false)
		XCTAssertEqual(chemicalElementsModel.nickel, true)
		XCTAssertEqual(chemicalElementsModel.cadmium, false)
		XCTAssertEqual(chemicalElementsModel.arsenic, true)
		XCTAssertEqual(chemicalElementsModel.chromium, false)
	}

	func testEmptyJSON() {
		let jsonString = "{}"

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var chemicalElementsModel = ChemicalElementsModel()
		chemicalElementsModel.deserialize(json)

		XCTAssertNil(chemicalElementsModel.lead)
		XCTAssertNil(chemicalElementsModel.mercury)
		XCTAssertNil(chemicalElementsModel.nickel)
		XCTAssertNil(chemicalElementsModel.cadmium)
		XCTAssertNil(chemicalElementsModel.arsenic)
		XCTAssertNil(chemicalElementsModel.chromium)
	}
}
