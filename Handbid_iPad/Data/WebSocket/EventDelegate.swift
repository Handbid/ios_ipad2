// Copyright (c) 2024 by Handbid. All rights reserved.

import Starscream

protocol EventDelegate: WebSocketDelegate {
	var userGuid: String? { get set }
	var auctionGuid: String? { get set }

	func didReceive(event: WebSocketEvent, client: WebSocketClient)

	func registerToUserChannel(client: WebSocketClient)
	func registerToAuctionChannel(client: WebSocketClient)

	func leaveUserChannel(client: WebSocketClient)
	func leaveAuctionChannel(client: WebSocketClient)
}
