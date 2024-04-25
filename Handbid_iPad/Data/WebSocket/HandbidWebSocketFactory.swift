// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SocketIO

class HandbidWebSocketFactory: WebSocketURLFactory {
	func getSocketURL(token _: TokenUser?) -> URL {
		URL(string: "\(EnvironmentManager.getCurrentSocketBaseURL())")!
	}
}
