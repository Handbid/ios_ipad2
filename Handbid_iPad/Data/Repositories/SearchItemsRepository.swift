// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Combine
import NetworkService

protocol SearchItemsRepository {
	func getSearchItems(name: String) -> AnyPublisher<[ItemModel], Error>
}

class SearchItemsRepositoryImpl: SearchItemsRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func getSearchItems(name: String) -> AnyPublisher<[ItemModel], Error> {
		get(ApiEndpoints.items, params: ["fields": name, "sort": "-\(name)", "page": 1])
			.tryMap { try ItemModel.decodeArray($0) }
			.eraseToAnyPublisher()
	}
}
