// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import NetworkService

class HandbidWebSocketFactory: WebSocketURLFactory {
	private let responseProvider: HandshakeResponseProvider

	init(responseProvider: HandshakeResponseProvider = DefaultHandshakeResponseProvider()) {
		self.responseProvider = responseProvider
	}

	func getSocketURL() throws -> URL {
		let responseString = try responseProvider.getHandshakeResponse(from: getSocketHandshakeURL())
		let delimeter = responseString.firstIndex(of: ":")

		if let index = delimeter {
			let sessionId = responseString[..<index]

			return URL(string: "\(getSocketHandshakeURL())/\(sessionId)")!
		}
		else {
			throw URLError(.badServerResponse)
		}
	}

	private func getSocketHandshakeURL() -> URL {
		URL(string: "\(EnvironmentManager.getCurrentSocketBaseURL())/socket.io/1/websocket")!
	}
}
