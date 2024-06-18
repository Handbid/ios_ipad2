// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol ChooseOrganizationRepository {
	func fetchUserOrganizations() -> AnyPublisher<[OrganizationModel], Error>
}

class ChooseOrganizationRepositoryImpl: ChooseOrganizationRepository, NetworkingService {
	var network: NetworkService.NetworkingClient
	@Published var organizations: [OrganizationModel] = .init()

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func fetchUserOrganizations() -> AnyPublisher<[OrganizationModel], Error> {
		get(ApiEndpoints.organizationIndex, params: ["page": "0", "per-page": "50"])
			.tryMap { try OrganizationModel.decodeArray($0) }
			.receive(on: DispatchQueue.main)
			.handleEvents(receiveOutput: { [weak self] organizations in
				self?.organizations = organizations
			})
			.eraseToAnyPublisher()
	}
}
