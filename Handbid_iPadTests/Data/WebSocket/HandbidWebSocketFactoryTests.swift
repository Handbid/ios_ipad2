// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import Starscream
import XCTest

class HandbidWebSocketFactoryTests: XCTestCase {
	var factory: HandbidWebSocketFactory!
	var mockResponseProvider: MockHandshakeResponseProvider!

	override func setUp() {
		super.setUp()
		mockResponseProvider = MockHandshakeResponseProvider()
		factory = HandbidWebSocketFactory(responseProvider: mockResponseProvider)
	}

	override func tearDown() {
		factory = nil
		mockResponseProvider = nil
		super.tearDown()
	}

	func testGetSocketURLWithValidResponse() {
		mockResponseProvider.response = "mockSessionId:mockData"
		let url = try? factory.getSocketURL()

		XCTAssertNotNil(url)
	}

	func testGetSocketURLWithInvalidResponse() {
		mockResponseProvider.response = "invalidResponse"

		XCTAssertThrowsError(try factory.getSocketURL()) { error in
			XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
		}
	}

	func testGetSocketURLWithError() {
		mockResponseProvider.error = URLError(.notConnectedToInternet)

		XCTAssertThrowsError(try factory.getSocketURL()) { error in
			XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
		}
	}
}
