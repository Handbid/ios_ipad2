// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import Starscream
import XCTest

class WebSocketManagerTests: XCTestCase {
	var webSocketManager: WebSocketManager!
	var mockURLFactory: MockWebSocketURLFactory!
	var mockToken: TokenUser!
	var mockWebSocket: MockWebSocket!

	override func setUp() {
		super.setUp()
		webSocketManager = WebSocketManager.shared
		mockURLFactory = MockWebSocketURLFactory()
		mockToken = TokenUser(validUntil: Date().addingTimeInterval(3600), id: UUID(), value: "efee7641f4f5e408886b73a2d0fa4cb10a9ad0f8", guid: "517b8b48-8f97-4e2c-aee5-091105a24dde")
		mockWebSocket = MockWebSocket()
	}

	override func tearDown() {
		webSocketManager.stopSocket()
		webSocketManager = nil
		mockURLFactory = nil
		mockToken = nil
		mockWebSocket = nil
		super.tearDown()
	}

	func testStartSocketWithValidURL() {
		mockURLFactory.url = URL(string: "https://rest.handbid.com/socket.io/1/websocket")
		let actualWebSocket = WebSocket(request: URLRequest(url: mockURLFactory.url!))
		webSocketManager.socket = actualWebSocket
		webSocketManager.startSocket(urlFactory: mockURLFactory, token: mockToken)
		XCTAssertNotNil(webSocketManager.socket)
		//        XCTAssertTrue(mockWebSocket.isConnected)
	}

	func testStartSocketWithInvalidURL() {
		mockURLFactory.error = URLError(.badURL)
		webSocketManager.startSocket(urlFactory: mockURLFactory, token: mockToken)
		XCTAssertNil(webSocketManager.socket, "Socket should be nil when URL is invalid")
	}

	func testStopSocket() {
		mockURLFactory.url = URL(string: "https://rest.handbid.com/socket.io/1/websocket")
		webSocketManager.startSocket(urlFactory: mockURLFactory, token: mockToken)
		let actualWebSocket = WebSocket(request: URLRequest(url: mockURLFactory.url!))
		webSocketManager.socket = actualWebSocket
		webSocketManager.stopSocket()

		XCTAssertNil(webSocketManager.socket)
		XCTAssertNil(webSocketManager.delegate)
	}
}
