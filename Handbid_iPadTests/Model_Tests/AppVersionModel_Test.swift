// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

final class AppVersionModel_Test: XCTestCase {
	func testAppVersionDataInit() {
		let json: [String: Any] = [
			"appVersion.id": 1,
			"appVersion.os": "iOS",
			"appVersion.appName": "Handbid",
			"appVersion.minimumVersion": "1.0",
			"appVersion.currentVersion": "2.0",
			"demoModeEnabled": 1,
		]

		let appVersionModel = AppVersionModel(json: json)

		XCTAssertEqual(appVersionModel.id, 1)
		XCTAssertEqual(appVersionModel.os, "iOS")
		XCTAssertEqual(appVersionModel.appName, "Handbid")
		XCTAssertEqual(appVersionModel.minimumVersion, "1.0")
		XCTAssertEqual(appVersionModel.currentVersion, "2.0")
		XCTAssertEqual(appVersionModel.demoModeEnabled, 1)

		XCTAssertNotNil(appVersionModel.id)
		XCTAssertNotNil(appVersionModel.os)
		XCTAssertNotNil(appVersionModel.appName)
		XCTAssertNotNil(appVersionModel.minimumVersion)
		XCTAssertNotNil(appVersionModel.currentVersion)
		XCTAssertNotNil(appVersionModel.demoModeEnabled)
	}

	func testAppVersionModelDeserialization() {
		let jsonDictionary: [String: Any] = [
			"appVersion.id": 1,
			"appVersion.os": "iOS",
			"appVersion.appName": "Handbid",
			"appVersion.minimumVersion": "1.0",
			"appVersion.currentVersion": "2.0",
			"demoModeEnabled": 1,
		]

		let jsonData = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: [])

		let json = JSON(jsonData)

		guard let appVersionModelJSON = json else {
			XCTFail("Failed to create JSON object.")
			return
		}

		var appVersionModel = AppVersionModel(json: jsonDictionary)
		appVersionModel.deserialize(appVersionModelJSON)

		XCTAssertEqual(appVersionModel.id, 1)
		XCTAssertEqual(appVersionModel.os, "iOS")
		XCTAssertEqual(appVersionModel.appName, "Handbid")
		XCTAssertEqual(appVersionModel.minimumVersion, "1.0")
		XCTAssertEqual(appVersionModel.currentVersion, "2.0")
		XCTAssertEqual(appVersionModel.demoModeEnabled, 1)

		XCTAssertNotNil(appVersionModel.id)
		XCTAssertNotNil(appVersionModel.os)
		XCTAssertNotNil(appVersionModel.appName)
		XCTAssertNotNil(appVersionModel.minimumVersion)
		XCTAssertNotNil(appVersionModel.currentVersion)
		XCTAssertNotNil(appVersionModel.demoModeEnabled)
	}
}
