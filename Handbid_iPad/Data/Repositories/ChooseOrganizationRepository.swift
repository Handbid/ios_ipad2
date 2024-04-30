// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

protocol ChooseOrganizationRepository {
	func fetchUserOrganization() -> AnyPublisher<UserModel, Error>
}

class ChooseOrganizationRepositoryImpl: ChooseOrganizationRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func fetchUserOrganization() -> AnyPublisher<UserModel, Error> {
		post(ApiEndpoints.auctionUser)
			.tryMap { try UserModel.decode($0) }
			.receive(on: DispatchQueue.global(qos: .background))
			.eraseToAnyPublisher()
	}
}
