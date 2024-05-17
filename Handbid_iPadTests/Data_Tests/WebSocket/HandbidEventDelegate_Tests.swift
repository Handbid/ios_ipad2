// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

class HandbidEventDelegateTests: XCTestCase {
	private var sut: HandbidEventDelegate!
	private var webSocketClient: MockWebSocketClient!

	override func setUp() {
		sut = HandbidEventDelegate()
		webSocketClient = MockWebSocketClient()
	}

	override func tearDown() {
		sut = nil
		webSocketClient = nil
	}

	func testDisconnectedEvent() {
		sut.didReceive(event: .disconnected("", 1), client: webSocketClient)
		XCTAssertFalse(webSocketClient.isConnected)

		let expectation = XCTestExpectation(description: "Client reconnects")

		DispatchQueue.global().asyncAfterSeconds(seconds: 6) {
			XCTAssert(self.webSocketClient.isConnected)

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testDisconnectingFromSocket() {
		sut.isClosing = true
		sut.didReceive(event: .disconnected("", 1), client: webSocketClient)
		XCTAssertFalse(webSocketClient.isConnected)

		let expectation = XCTestExpectation(description: "Client doesn't try to reconnect")

		DispatchQueue.global().asyncAfterSeconds(seconds: 6) {
			XCTAssertFalse(self.webSocketClient.isConnected)
			XCTAssertTrue(self.sut.isClosing)

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testTextEventWithConnectedMessage() {
		sut.didReceive(event: .text(HandbidEventDelegate.connectedMessage), client: webSocketClient)
		XCTAssertEqual(webSocketClient.writtenString, HandbidEventDelegate.registerMessage)
	}

	func testTextEventWithHeartbeatMessage() {
		sut.didReceive(event: .text(HandbidEventDelegate.heartbeatMessage), client: webSocketClient)
		XCTAssertEqual(webSocketClient.writtenString, HandbidEventDelegate.heartbeatMessage)
	}

	func testTextEventWithRegisterMessage() {
		sut.auctionGuid = "auction_guid"
		sut.userGuid = "user_guid"
		sut.didReceive(event: .text(HandbidEventDelegate.registerMessage), client: webSocketClient)

		XCTAssertTrue(webSocketClient.writtenString ==
			"5:1+:/client:{\"name\":\"room_join\",\"args\":[\"auction_guid_v2\"]}"
		)
	}
}
