// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

final class AppVersionModel_Test: XCTestCase {
	func testAppVersionModelDeserialization() throws {
		let jsonString = """
		{
		    "appVersion": {
		        "id": 1,
		        "os": "iOS",
		        "appName": "Handbid",
		        "minimumVersion": "1.0",
		        "currentVersion": "2.0"
		    },
		    "demoModeEnabled": 1
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var appVersionModel = AppVersionModel()
		appVersionModel.deserialize(json)

		XCTAssertEqual(appVersionModel.id, 1)
		XCTAssertEqual(appVersionModel.os, "iOS")
		XCTAssertEqual(appVersionModel.appName, "Handbid")
		XCTAssertEqual(appVersionModel.minimumVersion, "1.0")
		XCTAssertEqual(appVersionModel.currentVersion, "2.0")
		XCTAssertEqual(appVersionModel.demoModeEnabled, 1)
	}
}
