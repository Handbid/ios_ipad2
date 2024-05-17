// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class HandbidWebsocketFactoryTests: XCTestCase {
	private var sut: HandbidWebSocketFactory!
	private var responseProvider: MockHandshakeResponseProvider!

	override func setUp() {
		responseProvider = MockHandshakeResponseProvider()
		sut = HandbidWebSocketFactory(responseProvider: responseProvider)
	}

	override func tearDown() {
		sut = nil
		responseProvider = nil
	}

	func testGetSocketUrlWithValidHandshakeResponse() {
		var result: URL!
		XCTAssertNoThrow(result = try sut.getSocketURL())
		XCTAssert(result.path().hasSuffix("/socket.io/1/websocket/testResponse"))
	}

	func testGetSocketUrlWithInvalidHandshakeResponse() {
		responseProvider.response = "wrongResponse"
		XCTAssertThrowsError(try sut.getSocketURL())
	}
}
