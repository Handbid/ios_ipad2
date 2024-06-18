// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

final class UserProcessorTests: XCTestCase {
	func testProcessData() {
		let processor = UserProcessor()
		let data = [String: Any]()
		processor.process(data: data)
	}
}
