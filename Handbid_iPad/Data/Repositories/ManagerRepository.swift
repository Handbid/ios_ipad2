// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol ManagerRepository {
	func verifyManagerPin(_ pin: String, auctionId: Int) -> AnyPublisher<VerifyManagerPinModel, Error>
}

class ManagerRepositoryImpl: ManagerRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func verifyManagerPin(_ pin: String, auctionId: Int) -> AnyPublisher<VerifyManagerPinModel, Error> {
		let params = ["pin": pin]

		return post("\(ApiEndpoints.verifyManagerPin)\(auctionId)", body: params)
			.tryMap { try VerifyManagerPinModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}
}
