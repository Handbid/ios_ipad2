// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockCountriesRepository: CountriesRepository {
	var returnedCountriesPublisher = Result {
		[CountryModel]()
	}
	.publisher
	.eraseToAnyPublisher()

	func getCountries() -> AnyPublisher<[CountryModel], any Error> {
		returnedCountriesPublisher
	}
}
