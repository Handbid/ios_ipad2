// Copyright (c) 2024 by Handbid. All rights reserved.

import Starscream

class EventDelegate: WebSocketDelegate {
	private static let heartbeatMessage = "2::"
	private static let connectedMessage = "1::"
	private static let registerMessage = "1::/client"

	private var isClosing = false

	func didReceive(event: WebSocketEvent, client: WebSocketClient) {
		switch event {
		case .connected:
			print("Connected to websocket")
		case .disconnected:
			if !isClosing {
				reconnectSocket(client: client)
			}
			else {
				print("Disconnected from websocket")
			}
		case let .text(data):
			handleMessage(message: data, client: client)
			print("received: \(data)")
		case let .binary(data):
			let message = String(data: data, encoding: .utf8) ?? ""
			handleMessage(message: message, client: client)
			print("received: \(data)")
		case .pong:
			break
		case .ping:
			break
		case let .error(error):
			print(error!)
		case let .viabilityChanged(changed):
			if changed {
				reconnectSocket(client: client)
			}
		case let .reconnectSuggested(suggested):
			if suggested {
				reconnectSocket(client: client)
			}
		case .cancelled:
			reconnectSocket(client: client)
		case .peerClosed:
			break
		}
	}

	private func reconnectSocket(client: WebSocketClient) {
		client.disconnect()
		DispatchQueue.global().asyncAfterSeconds(seconds: 5) {
			client.connect()
		}
	}

	private func handleMessage(message: String, client: WebSocketClient) {
		switch message {
		case EventDelegate.connectedMessage:
			registerOnServer(client: client)
		case EventDelegate.heartbeatMessage:
			heartbeat(client: client)
		case EventDelegate.registerMessage:
			break
		default:
			break
		}
	}

	private func heartbeat(client: WebSocketClient) {
		client.write(string: EventDelegate.heartbeatMessage)
		print("Sent heartbeat: \(EventDelegate.heartbeatMessage)")
	}

	private func registerOnServer(client: WebSocketClient) {
		client.write(string: EventDelegate.registerMessage)
		print("register client on node: \(EventDelegate.registerMessage)")
	}
}
