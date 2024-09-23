// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol MyBidsRepository {
	func findBidder(paddleId: String, auctionId: Int) -> AnyPublisher<BidderModel, Error>
}

class MyBidsRepositoryImpl: MyBidsRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func findBidder(paddleId: String, auctionId: Int) -> AnyPublisher<BidderModel, Error> {
		get(ApiEndpoints.findBidder, params: ["paddleId": paddleId,
		                                      "auctionId": auctionId])
			.tryMap { try BidderModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}
}
