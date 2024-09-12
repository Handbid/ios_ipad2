// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockPaddleViewModel: PaddleViewModel {
	var wasConfirmFoundUserCalled = false
	var lastConfirmFoundUserModel: RegistrationModel?
	var wasRequestFindingPaddleCalled = false
	var wasRegisterNewUserCalled = false

	init() {
		super.init(paddleRepository: MockPaddleRepository(),
		           countriesRepository: MockCountriesRepository())
	}

	override func confirmFoundUser(model: RegistrationModel) {
		wasConfirmFoundUserCalled = true
		lastConfirmFoundUserModel = model
	}

	override func requestFindingPaddle() {
		wasRequestFindingPaddleCalled = true
	}

	override func fetchCountries() {
		countries = [
			CountryModel(id: 1,
			             name: "United States of America",
			             countryCode: "US",
			             phoneCode: "1"),
			CountryModel(id: 1,
			             name: "Poland",
			             countryCode: "PL",
			             phoneCode: "48"),
		]
	}

	override func registerNewUser() {
		wasRegisterNewUserCalled = true
	}
}
