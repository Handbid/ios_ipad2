// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol CountriesRepository {
	func getCountries() -> AnyPublisher<[CountryModel], Error>
}

class CountriesRepositoryImpl: CountriesRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func getCountries() -> AnyPublisher<[CountryModel], any Error> {
		get(ApiEndpoints.getCountries)
	}
}
