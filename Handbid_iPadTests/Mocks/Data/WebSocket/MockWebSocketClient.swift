// Copyright (c) 2024 by Handbid. All rights reserved.

import Starscream

class MockWebSocketClient: WebSocketClient {
	var isConnected = false
	var writtenData = Data()
	var writtenString: String = ""

	func write(string: String, completion _: (() -> Void)?) {
		writtenString = string
	}

	func write(stringData: Data, completion _: (() -> Void)?) {
		writtenData = stringData
	}

	func write(data: Data, completion _: (() -> Void)?) {
		writtenData = data
	}

	func write(ping: Data, completion _: (() -> Void)?) {
		writtenData = ping
	}

	func write(pong: Data, completion _: (() -> Void)?) {
		writtenData = pong
	}

	func disconnect(closeCode _: UInt16) {
		isConnected = false
	}

	func connect() {
		isConnected = true
	}
}
