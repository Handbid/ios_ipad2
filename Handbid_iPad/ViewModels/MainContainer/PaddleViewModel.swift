// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class PaddleViewModel: ObservableObject, ViewModelTopBarProtocol {
	private let paddleRepository: PaddleRepository
	private let countryRepository: CountriesRepository

	@Published var title = "Paddle Number"
	@Published var pickedMethod: SearchBy
	@Published var subView: PaddleView.SubView
	@Published var email: String
	@Published var phone: String
	@Published var countryCode: String
	@Published var error: String
	var auctionId: Int
	var auctionGuid: String

	private let dataManager = DataManager.shared

	@Published var countries: [CountryModel]
	@Published var isLoading: Bool = false

	@Published var firstName: String
	@Published var lastName: String
	var actions: [TopBarAction] { [] }
	private var cancellables = Set<AnyCancellable>()

	init(paddleRepository: PaddleRepository,
	     countriesRepository: CountriesRepository)
	{
		self.paddleRepository = paddleRepository
		self.countryRepository = countriesRepository
		self.pickedMethod = .email
		self.subView = .findPaddle
		self.email = ""
		self.phone = ""
		self.countryCode = Locale.current.region?.identifier.uppercased() ?? "US"
		self.error = ""
		self.firstName = ""
		self.lastName = ""
		self.countries = []
		self.auctionId = -1
		self.auctionGuid = ""

		dataManager.onDataChanged.sink {
			self.updateAuctionId()
		}.store(in: &cancellables)

		fetchCountries()
		updateAuctionId()
		setUpClearingError()
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	private func updateAuctionId() {
		guard let auction = try? dataManager.fetchSingle(of: AuctionModel.self, from: .auction),
		      let auctionId = auction.identity,
		      let auctionGuid = auction.auctionGuid
		else { return }

		self.auctionId = auctionId
		self.auctionGuid = auctionGuid
	}

	private func setUpClearingError() {
		let fields = [$email, $phone, $firstName, $lastName]

		for field in fields {
			field.sink { _ in
				self.clearError()
			}.store(in: &cancellables)
		}

		$pickedMethod.sink { _ in
			self.clearError()
		}.store(in: &cancellables)
	}

	func clearError() {
		error = ""
	}

	func fetchCountries() {
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
						guard let phoneCode = country.phoneCode,
						      let countryCode = country.countryCode
						else { return false }

						return !phoneCode.isEmpty && countryCode.count == 2
					}
				}
			).store(in: &cancellables)
	}

	func requestFindingPaddle() {
		isLoading = true
		var identifier = ""
		switch pickedMethod {
		case .cellPhone:
			identifier = phone
			if identifier.isEmpty {
				error = String(localized: "paddle_hint_emptyPhone")
				isLoading = false
				return
			}
		case .email:
			identifier = email
			if !identifier.isValidEmail() {
				error = String(localized: "paddle_hint_incorrectEmail")
				isLoading = false
				return
			}
		}

		paddleRepository.findPaddle(identifier: identifier, auctionId: auctionId)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: {
				self.isLoading = false
				switch $0 {
				case .finished:
					print("Finished finding user")
				case let .failure(e):
					print("Error finding user: \(e)")
					self.error = e.localizedDescription
				}
			}, receiveValue: { response in
				if response.status == "FOUND" {
					self.subView = .userFound(response)
				}
				else {
					self.error = String(localized: "paddle_label_paddleNotFound")
				}
			})
			.store(in: &cancellables)
	}

	func confirmFoundUser(model: RegistrationModel) {
		if model.isCheckedIn == 1 {
			subView = .findPaddle
		}
		else {
			guard let paddle = model.currentPaddleNumber
			else {
				subView = .findPaddle
				return
			}
			isLoading = true
			paddleRepository.checkInUser(paddleNumber: paddle, auctionId: auctionId)
				.receive(on: DispatchQueue.main)
				.sink(receiveCompletion: {
					self.isLoading = false
					switch $0 {
					case .finished:
						print("Finished checking user in")
					case let .failure(error):
						print("Failed checking user in: \(error.localizedDescription)")
						self.error = error.localizedDescription
						self.subView = .findPaddle
					}
				}, receiveValue: { _ in
					self.subView = .findPaddle
					self.clearError()
				})
				.store(in: &cancellables)
		}
	}

	private func validateDataForRegistration() -> Bool {
		clearError()

		if firstName.isEmpty || lastName.isEmpty {
			error = String(localized: "paddle_hint_emptyName")
			return false
		}
		else if !email.isValidEmail() {
			error = String(localized: "paddle_hint_incorrectEmail")
			return false
		}
		else if phone.isEmpty {
			error = String(localized: "paddle_hint_emptyPhone")
			return false
		}
		else {
			return true
		}
	}

	func registerNewUser() {
		isLoading = true
		if validateDataForRegistration() {
			Task {
				var response = RegistrationModel()

				do {
					response = try await self.paddleRepository
						.registerUser(firstName: self.firstName,
						              lastName: self.lastName,
						              phoneNumber: self.phone,
						              countryCode: self.countryCode,
						              email: self.email,
						              auctionGuid: self.auctionGuid)
				}
				catch {
					print(error)
					DispatchQueue.safeMainAsync {
						self.error = error.localizedDescription
						self.isLoading = false
					}
					return
				}

				if response.success != true {
					DispatchQueue.safeMainAsync {
						self.isLoading = false
						self.error = response.errorMessage ?? String(localized: "global_label_unknownError")
					}
				}
				else if response.status == "New-Registration Succeeded" {
					DispatchQueue.safeMainAsync {
						self.subView = .confirmInformation(response)
						self.isLoading = false
					}
				}
				else {
					DispatchQueue.safeMainAsync {
						self.subView = .userFound(response)
						self.isLoading = false
					}
				}
			}
		}
		else {
			isLoading = false
		}
	}
}
