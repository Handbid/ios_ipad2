// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService
import Starscream
import XCTest

class MockWebSocketURLFactory: WebSocketURLFactory {
	var url: URL?
	var error: Error?

	func getSocketURL() throws -> URL {
		if let error {
			throw error
		}
		return url!
	}
}

class MockWebSocket: WebSocketClient {
	var didConnect = false
	var didDisconnect = false
	var didWriteString = false
	var isConnected = false

	var delegate: WebSocketDelegate?

	func connect() {
		didConnect = true
		isConnected = true
		delegate?.didReceive(event: .connected(["": ""]), client: self)
	}

	func disconnect(closeCode: UInt16) {
		didDisconnect = true
		isConnected = false
		delegate?.didReceive(event: .disconnected("Disconnected", closeCode), client: self)
	}

	func write(string _: String, completion: (() -> Void)?) {
		didWriteString = true
		completion?()
	}

	func write(stringData _: Data, completion: (() -> Void)?) {
		didWriteString = true
		completion?()
	}

	func write(data _: Data, completion: (() -> Void)?) {
		didWriteString = true
		completion?()
	}

	func write(ping _: Data, completion: (() -> Void)?) {
		completion?()
	}

	func write(pong _: Data, completion: (() -> Void)?) {
		completion?()
	}
}

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
//		XCTAssertTrue(mockWebSocket.isConnected)
	}

	func testStartSocketWithInvalidURL() {
		mockURLFactory.error = URLError(.badURL)
		webSocketManager.startSocket(urlFactory: mockURLFactory, token: mockToken)
		XCTAssertNil(webSocketManager.socket)
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

class MockHandshakeResponseProvider: HandshakeResponseProvider {
	var response: String?
	var error: Error?

	func getHandshakeResponse(from _: URL) throws -> String {
		if let error {
			throw error
		}
		return response ?? ""
	}
}

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

class HandbidEventDelegateTests: XCTestCase {
	var delegate: HandbidEventDelegate!
	var mockClient: MockWebSocket!

	override func setUp() {
		super.setUp()
		delegate = HandbidEventDelegate()
		mockClient = MockWebSocket()
		mockClient.delegate = delegate
	}

	override func tearDown() {
		delegate = nil
		mockClient = nil
		super.tearDown()
	}

	func testDidReceiveConnectedEvent() {
		delegate.didReceive(event: .connected(["": ""]), client: mockClient)
	}

	func testDidReceiveDisconnectedEvent() {
		delegate.didReceive(event: .disconnected("", 1000), client: mockClient)
	}

	func testDidReceiveTextEvent() {
		delegate.didReceive(event: .text("test message"), client: mockClient)
	}

	func testDidReceiveBinaryEvent() {
		delegate.didReceive(event: .binary(Data()), client: mockClient)
	}

	func testDidReceiveErrorEvent() {
		delegate.didReceive(event: .error(URLError(.badServerResponse)), client: mockClient)
	}

	func testDidReceiveViabilityChangedEvent() {
		delegate.didReceive(event: .viabilityChanged(true), client: mockClient)
	}

	func testDidReceiveReconnectSuggestedEvent() {
		delegate.didReceive(event: .reconnectSuggested(true), client: mockClient)
	}

	func testDidReceiveCancelledEvent() {
		delegate.didReceive(event: .cancelled, client: mockClient)
	}
}
