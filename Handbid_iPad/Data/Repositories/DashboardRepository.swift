// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol DashboardRepository {
	func fetchDashboard(auctionGuid: String) -> AnyPublisher<DashboardModel, Error>
}

class DashboardRepositoryImpl: DashboardRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func fetchDashboard(auctionGuid: String) -> AnyPublisher<DashboardModel, any Error> {
		let body = [
			"aGuid": auctionGuid,
		]

		return post(ApiEndpoints.fetchDashboard, params: body)
			.tryMap { try DashboardModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}
}
