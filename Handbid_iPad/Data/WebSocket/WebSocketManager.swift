// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import Starscream

class WebSocketManager {
	static var socket: WebSocket?
	static var delegate: WebSocketDelegate?

	static func startSocket(urlFactory: WebSocketURLFactory, token: TokenUser?) {
		do {
			let url = try urlFactory.getSocketURL()

			var urlRequest = URLRequest(url: url)
			urlRequest.setValue("PHPSESSID=\(token?.value ?? "")", forHTTPHeaderField: "cookie")

			socket = WebSocket(request: urlRequest)

			delegate = EventDelegate()
			socket?.delegate = delegate

			socket?.connect()
		}
		catch {
			print(error)
		}
	}
}
