// Copyright (c) 2024 by Handbid. All rights reserved.

import os
import Starscream

class HandbidEventDelegate: EventDelegate {
	var userGuid: String?

	var auctionGuid: String?

	static let heartbeatMessage = "2::"
	static let connectedMessage = "1::"
	static let registerMessage = "1::/client"

	private var logger: Logger?
	var isClosing = false

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
		case .peerClosed, .pong, .ping:
			break
		}
	}

	private func reconnectSocket(client: WebSocketClient) {
		isClosing = true
		client.disconnect()
		DispatchQueue.global().asyncAfterSeconds(seconds: 5) {
			client.connect()
			self.isClosing = false
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
			parseEvent(message: message)
		}
	}

	private func parseEvent(message: String) {
		let regex = /client:\d+\+\[.*.\d+\]/
		if (try? regex.firstMatch(in: message)) != nil {
			logger?.log("Ignoring message: \(message)")
			return
		}

		guard let startIndex = message.firstIndex(of: "{") else {
			logger?.error("Message does not contain a valid JSON start: \(message)")
			return
		}

		let jsonString = String(message[startIndex...])
		guard let jsonData = jsonString.data(using: .utf8) else {
			logger?.error("Failed to encode jsonString to Data")
			return
		}

		do {
			guard let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
			      let name = json["name"] as? String,
			      let args = json["args"] as? [[String: Any]]
			else {
				logger?.error("JSON does not contain required keys 'name' or 'args'")
				return
			}

			let data = name.split(separator: ":")
			guard data.count >= 3, !data[1].isEmpty else {
				logger?.log("Ignoring message due to insufficient data parts or empty room: \(name)")
				return
			}

			let eventId = String(data[2])
			guard eventId != "system" else {
				logger?.log("Ignoring node of type system: \(name)")
				return
			}

			guard let eventType = Processor(rawValue: eventId),
			      args.count > 0
			else {
				logger?.log("Ignoring event of type \(eventId) due to processing failure")
				return
			}

			let processor = ProcessorRegistry.shared.getProcessor(for: eventType)
			processor?.process(data: args[0])
		}
		catch {
			logger?.error("Failed to parse JSON: \(error.localizedDescription)")
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
