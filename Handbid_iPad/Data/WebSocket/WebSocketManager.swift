// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import Starscream

class WebSocketManager {
	static var socket: WebSocket?
	static var delegate: EventDelegate?

	static func startSocket(urlFactory: WebSocketURLFactory, token: TokenUser?) {
		do {
			let url = try urlFactory.getSocketURL()

			var urlRequest = URLRequest(url: url)
			urlRequest.setValue("PHPSESSID=\(token?.value ?? "")", forHTTPHeaderField: "cookie")

			socket = WebSocket(request: urlRequest)

			delegate = HandbidEventDelegate()
			delegate?.userGuid = token?.guid
			socket?.delegate = delegate

			socket?.connect()
		}
		catch {
			print(error)
		}
	}

	static func stopSocket() {
		if let client = socket {
			delegate?.leaveAuctionChannel(client: client)
			delegate?.leaveUserChannel(client: client)
			client.disconnect()
		}

		delegate = nil
		socket = nil
	}
}
