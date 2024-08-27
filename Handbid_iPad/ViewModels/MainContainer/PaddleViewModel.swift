// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class PaddleViewModel: ObservableObject, ViewModelTopBarProtocol {
	private let paddleRepository: PaddleRepository
	private let countryRepository: CountriesRepository

	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Paddle Number"
	@Published var pickedMethod: SearchBy
	@Published var email: String
	@Published var phone: String
	@Published var countryCode: String
	@Published var error: String

	@Published var countries: [CountryModel]

	@Published var firstName: String
	@Published var lastName: String
	@Published var user: UserModel?
	var actions: [TopBarAction] { [] }
	private var cancellables = Set<AnyCancellable>()

	init(dataService: DataServiceWrapper,
	     paddleRepository: PaddleRepository,
	     countriesRepository: CountriesRepository)
	{
		self.dataService = dataService
		self.paddleRepository = paddleRepository
		self.countryRepository = countriesRepository
		self.pickedMethod = .email
		self.email = ""
		self.phone = ""
		self.countryCode = Locale.current.region?.identifier.uppercased() ?? "US"
		self.error = ""
		self.firstName = ""
		self.lastName = ""
		self.user = nil
		self.countries = []

		fetchCountries()
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	private func fetchCountries() {
		countryRepository.getCountries()
			.sink(
				receiveCompletion: { completion in
					switch completion {
					case .finished:
						break
					case let .failure(e):
						self.error = e.localizedDescription
					}
				},
				receiveValue: { countries in
					self.countries = countries.filter { country in
						country.phoneCode != nil && country.countryCode != nil
					}
				}
			).store(in: &cancellables)
	}
}
