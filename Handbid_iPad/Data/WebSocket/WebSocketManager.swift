// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SocketIO

class WebSocketManager {
	private static var socketManager: SocketManager?
	static var socket: SocketIOClient?

    static func startSocket(urlFactory: WebSocketURLFactory, token: TokenUser?) {
        let url = urlFactory.getSocketURL(token: token)
        let cookie = HTTPCookie(properties: [
            .domain: url.host() ?? "",
            .path: "/",
            .name: "PHPSESSID",
            .value: token?.value ?? "",
            .secure: true,
        ])!
        socketManager = SocketManager(socketURL: url,
                                      config: [.log(true),
                                               .cookies([cookie])])
        socket = socketManager?.socket(forNamespace: "/client")
        
        socket?.on(clientEvent: .connect) { _, _ in
            print("Socket connected")
        }
        socket?.on(clientEvent: .error) { data, _ in
            print(data)
        }
        
        socket?.connect()
    }
}
