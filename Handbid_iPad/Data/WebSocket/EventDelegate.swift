// Copyright (c) 2024 by Handbid. All rights reserved.

import Starscream

class EventDelegate: WebSocketDelegate {
	func didReceive(event: Starscream.WebSocketEvent, client _: Starscream.WebSocketClient) {
		switch event {
		case .connected:
			print("Connected to websocket")
		case .disconnected:
			print("Disconnected from websocket")
		case let .text(data):
			print("received: \(data)")
		case let .binary(data):
			print("received: \(data)")
		case .pong:
			break
		case .ping:
			break
		case let .error(error):
			print(error!)
		case .viabilityChanged:
			break
		case .reconnectSuggested:
			break
		case .cancelled:
			break
		case .peerClosed:
			break
		}
	}
}
