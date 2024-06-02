// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import Starscream

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
