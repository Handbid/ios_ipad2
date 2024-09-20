// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockCountriesRepository: CountriesRepository {
	var returnedCountriesPublisher: AnyPublisher<[CountryModel], Error> =
		Result { [CountryModel]() }
			.publisher
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()

	func getCountries() -> AnyPublisher<[CountryModel], any Error> {
		returnedCountriesPublisher
	}
}
