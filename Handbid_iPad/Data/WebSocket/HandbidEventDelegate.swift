// Copyright (c) 2024 by Handbid. All rights reserved.

import os
import Starscream

class HandbidEventDelegate: EventDelegate {
	var userGuid: String?

	var auctionGuid: String?

	private static let heartbeatMessage = "2::"
	private static let connectedMessage = "1::"
	private static let registerMessage = "1::/client"

	private var logger: Logger?
	private var isClosing = false

	#if Debug
		init() {
			self.logger = Logger()
		}
	#endif

	func didReceive(event: WebSocketEvent, client: WebSocketClient) {
		switch event {
		case .connected:
			logger?.log("Connected to websocket")
		case .disconnected:
			if !isClosing {
				reconnectSocket(client: client)
			}
			else {
				logger?.log("Disconnected from websocket")
			}
		case let .text(data):
			logger?.log("received: \(data)")
			handleMessage(message: data, client: client)
		case let .binary(data):
			logger?.log("received: \(data)")
			let message = String(data: data, encoding: .utf8) ?? ""
			handleMessage(message: message, client: client)
		case .pong:
			break
		case .ping:
			break
		case let .error(error):
			logger?.error("Websocket error: \(error.debugDescription)")
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
		case HandbidEventDelegate.connectedMessage:
			registerOnServer(client: client)
		case HandbidEventDelegate.heartbeatMessage:
			heartbeat(client: client)
		case HandbidEventDelegate.registerMessage:
			registerToUserChannel(client: client)
			registerToAuctionChannel(client: client)
		default:
			logger?.log("received: \(message)")
		}
	}

	private func heartbeat(client: WebSocketClient) {
		client.write(string: HandbidEventDelegate.heartbeatMessage)
		logger?.log("Sent heartbeat: \(HandbidEventDelegate.heartbeatMessage)")
	}

	private func registerOnServer(client: WebSocketClient) {
		client.write(string: HandbidEventDelegate.registerMessage)
		logger?.log("register client on node: \(HandbidEventDelegate.registerMessage)")
	}

	private func registerToChannel(client: WebSocketClient, channelGuid guid: String) {
		let command = "5:1+:/client:{\"name\":\"room_join\",\"args\":[\"\(guid)_v2\"]}"
		client.write(string: command)
		logger?.log("joining channel: \(command)")
	}

	private func leaveChannel(client: WebSocketClient, channelGuid guid: String) {
		let command = "5:1+:/client:{\"name\":\"room_leave\",\"args\":[\"\(guid)_v2\"]}"
		client.write(string: command)
		logger?.log("leaving channel: \(command)")
	}

	func registerToUserChannel(client: WebSocketClient) {
		if let guid = userGuid {
			registerToChannel(client: client, channelGuid: guid)
		}
	}

	func registerToAuctionChannel(client: WebSocketClient) {
		if let guid = auctionGuid {
			registerToChannel(client: client, channelGuid: guid)
		}
	}

	func leaveUserChannel(client: WebSocketClient) {
		if let guid = userGuid {
			leaveChannel(client: client, channelGuid: guid)
		}
	}

	func leaveAuctionChannel(client: WebSocketClient) {
		if let guid = auctionGuid {
			leaveChannel(client: client, channelGuid: guid)
		}
	}
}
