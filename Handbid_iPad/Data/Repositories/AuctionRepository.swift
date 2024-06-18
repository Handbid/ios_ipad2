// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import NetworkService

protocol AuctionRepository {
	func getAuctionDetails(id: Int) -> AnyPublisher<AuctionModel, Error>
}

class AuctionRepositoryImpl: AuctionRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func getAuctionDetails(id: Int) -> AnyPublisher<AuctionModel, any Error> {
		get(ApiEndpoints.auctionInventory, params: ["id": id])
			.tryMap { try AuctionModel.decode($0) }
			.eraseToAnyPublisher()
	}
}
