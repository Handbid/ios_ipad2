// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import Starscream
import XCTest

class WebSocketManagerTests: XCTestCase {
	var webSocketManager: WebSocketManager!
	var mockURLFactory: MockWebSocketURLFactory!
	var mockToken: TokenUser!
	var mockWebSocket: MockWebSocket!
	var mockAuctionGuid: String!

	override func setUp() {
		super.setUp()
		webSocketManager = WebSocketManager.shared
		mockURLFactory = MockWebSocketURLFactory()
		mockToken = TokenUser(validUntil: Date().addingTimeInterval(3600), id: UUID(), value: "efee7641f4f5e408886b73a2d0fa4cb10a9ad0f8", guid: "517b8b48-8f97-4e2c-aee5-091105a24dde")
		mockWebSocket = MockWebSocket()
		mockAuctionGuid = "7fc46c89-da9f-4c19-8905-6df79aa544ad"
	}

	override func tearDown() {
		webSocketManager.stopSocket()
		webSocketManager = nil
		mockURLFactory = nil
		mockToken = nil
		mockWebSocket = nil
		mockAuctionGuid = nil
		super.tearDown()
	}

	func testStartSocketWithValidURL() {
		mockURLFactory.url = URL(string: "https://rest.handbid.com/socket.io/1/websocket")
		let actualWebSocket = WebSocket(request: URLRequest(url: mockURLFactory.url!))
		webSocketManager.socket = actualWebSocket
		webSocketManager.startSocket(urlFactory: mockURLFactory,
		                             token: mockToken,
		                             auctionGuid: mockAuctionGuid)
		XCTAssertNotNil(webSocketManager.socket)
	}

	func testStartSocketWithInvalidURL() {
		mockURLFactory.error = URLError(.badURL)
		webSocketManager.startSocket(urlFactory: mockURLFactory,
		                             token: mockToken,
		                             auctionGuid: mockAuctionGuid)
		XCTAssertNil(webSocketManager.socket, "Socket should be nil when URL is invalid")
	}

	func testStopSocket() {
		mockURLFactory.url = URL(string: "https://rest.handbid.com/socket.io/1/websocket")
		webSocketManager.startSocket(urlFactory: mockURLFactory,
		                             token: mockToken,
		                             auctionGuid: mockAuctionGuid)
		let actualWebSocket = WebSocket(request: URLRequest(url: mockURLFactory.url!))
		webSocketManager.socket = actualWebSocket
		webSocketManager.stopSocket()

		XCTAssertNil(webSocketManager.socket)
		XCTAssertNil(webSocketManager.delegate)
	}
}
