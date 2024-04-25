// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService

class HandbidWebSocketFactory: WebSocketURLFactory {
	func getSocketURL() throws -> URL {
		let responseString = try String(contentsOf: getSocketHandshakeURL(), encoding: .utf8)
		let delimeter = responseString.firstIndex(of: ":")!
		let sessionId = responseString[..<delimeter]

		return URL(string: "\(getSocketHandshakeURL())/\(sessionId)")!
	}

	private func getSocketHandshakeURL() -> URL {
		URL(string: "\(EnvironmentManager.getCurrentSocketBaseURL())/socket.io/1/websocket")!
	}
}
