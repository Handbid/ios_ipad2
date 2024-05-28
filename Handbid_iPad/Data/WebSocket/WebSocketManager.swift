// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import Starscream

class WebSocketManager {
	static let shared = WebSocketManager()
	var socket: WebSocket?
	var delegate: EventDelegate?

	func startSocket(urlFactory: WebSocketURLFactory, token: TokenUser?) {
		do {
			let url = try urlFactory.getSocketURL()

			var urlRequest = URLRequest(url: url)
			urlRequest.setValue("PHPSESSID=\(token?.value ?? "")", forHTTPHeaderField: "cookie")

			socket = WebSocket(request: urlRequest)

			initProcessorRegistry()
			delegate = HandbidEventDelegate()
			delegate?.userGuid = token?.guid
			socket?.delegate = delegate

			socket?.connect()
		}
		catch {
			print(error)
		}
	}

	func stopSocket() {
		if let client = socket {
			delegate?.leaveAuctionChannel(client: client)
			delegate?.leaveUserChannel(client: client)
			delegate?.isClosing = true
			client.disconnect()
		}

		delegate = nil
		socket = nil
	}

	private func initProcessorRegistry() {
		ProcessorRegistry.shared.registerProcessor(UserProcessor(), for: .user)
	}
}