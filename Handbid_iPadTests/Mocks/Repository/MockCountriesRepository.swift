// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockCountriesRepository: CountriesRepository {
	func getCountries() -> AnyPublisher<[CountryModel], any Error> {
		Result {
			[CountryModel]()
		}
		.publisher
		.eraseToAnyPublisher()
	}
}
