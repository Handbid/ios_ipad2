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
	private var auctionId: Int

	private let dataManager = DataManager.shared

	@Published var countries: [CountryModel]
	@Published var isLoading: Bool = false

	@Published var firstName: String
	@Published var lastName: String
	@Published var user: UserModel?
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
		self.user = nil
		self.countries = []
		self.auctionId = -1

		dataManager.onDataChanged.sink {
			self.updateAuctionId()
		}.store(in: &cancellables)

		fetchCountries()
		updateAuctionId()
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}

	private func updateAuctionId() {
		do {
			guard let auction = try dataManager.fetchSingle(of: AuctionModel.self, from: .auction),
			      let auctionId = auction.identity
			else { return }

			self.auctionId = auctionId
		}
		catch {
			self.error = error.localizedDescription
		}
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

	func requestFindingPaddle() {
		isLoading = true
		let identifier = switch pickedMethod {
		case .cellPhone:
			phone
		case .email:
			email
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
				})
				.store(in: &cancellables)
		}
	}
}
