// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
@testable import Handbid_iPad
import XCTest

final class ResetPasswordModel_Test: XCTestCase {
	func testResetPasswordModelDeserialization() {
		let jsonString = """
		{
		    "success": true,
		    "data": {
		        "message": "Password reset successful"
		    }
		}
		"""

		guard let json = JSON(jsonString) else {
			XCTFail("Failed to parse JSON")
			return
		}

		var resetPasswordModel = ResetPasswordModel()
		resetPasswordModel.deserialize(json)

		XCTAssertEqual(resetPasswordModel.success, true)
		XCTAssertEqual(resetPasswordModel.message, "Password reset successful")
	}
}
