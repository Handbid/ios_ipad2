// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import Starscream
import XCTest

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
