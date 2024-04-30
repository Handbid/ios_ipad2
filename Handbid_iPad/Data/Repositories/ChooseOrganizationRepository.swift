// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

protocol ChooseOrganizationRepository {
	func fetchUserOrganization() -> AnyPublisher<ResetPasswordModel, Error>
}

class ChooseOrganizationRepositoryImpl: ChooseOrganizationRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func fetchUserOrganization() -> AnyPublisher<ResetPasswordModel, Error> {
		post(ApiEndpoints.auctionUser)
			.tryMap { try ResetPasswordModel.decode($0) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}
