// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class PaddleViewModelTests: XCTestCase {
	var viewModel: PaddleViewModel!
	var mockPaddleRepository: MockPaddleRepository!
	var mockCountriesRepository: MockCountriesRepository!
	var cancellables = Set<AnyCancellable>()

	override func setUp() {
		super.setUp()
		mockPaddleRepository = MockPaddleRepository()
		mockCountriesRepository = MockCountriesRepository()
		viewModel = PaddleViewModel(paddleRepository: mockPaddleRepository,
		                            countriesRepository: mockCountriesRepository)
	}

	override func tearDown() {
		viewModel = nil
		mockPaddleRepository = nil
		mockCountriesRepository = nil
		cancellables.removeAll()
		try? DataManager.shared.deleteAll(of: AuctionModel.self, from: .auction)
		super.tearDown()
	}

	func getLoadingCycleExpectation() -> XCTestExpectation {
		let expLoading = expectation(description: "isLoading goes false -> true -> false")
		var lastValue = false
		var goneFromFalseToTrue = false
		var goneFromTrueToFalse = false

		viewModel.$isLoading.sink { loading in
			if lastValue != loading {
				if loading {
					goneFromFalseToTrue = true
				}
				else {
					goneFromTrueToFalse = true
				}

				if goneFromFalseToTrue, goneFromTrueToFalse {
					expLoading.fulfill()
				}
			}
			lastValue = loading
		}.store(in: &cancellables)

		return expLoading
	}

	func testUpdateAuctionId() {
		let auction = AuctionModel(id: "test", identity: 1, auctionGuid: "test")

		XCTAssertNoThrow(try DataManager.shared.create(auction, in: .auction))

		XCTAssertEqual(viewModel.error, "")
		XCTAssertEqual(viewModel.auctionId, 1)
		XCTAssertEqual(viewModel.auctionGuid, "test")
	}

	func testUpdateAuctionIdWhenNoAuctionIsStored() {
		XCTAssertEqual(viewModel.auctionId, -1)
		XCTAssertTrue(viewModel.auctionGuid.isEmpty)
	}

	func testFetchCountriesSuccessfully() {
		mockCountriesRepository.returnedCountriesPublisher =
			Just([CountryModel(id: 1,
			                   name: "United States of America",
			                   countryCode: "US",
			                   phoneCode: "1"),
			      CountryModel(id: 2,
			                   name: "Unknown")])
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()

		viewModel = PaddleViewModel(paddleRepository: mockPaddleRepository,
		                            countriesRepository: mockCountriesRepository)

		XCTAssertEqual(viewModel.countries.count, 1)
	}

	func testFetchCountriesWithError() {
		mockCountriesRepository.returnedCountriesPublisher =
			Fail(error: URLError(.badServerResponse))
				.delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
				.eraseToAnyPublisher()

		let expectation = expectation(description: "Error is updated")

		viewModel = PaddleViewModel(paddleRepository: mockPaddleRepository,
		                            countriesRepository: mockCountriesRepository)

		viewModel.$error
			.sink { error in
				if !error.isEmpty {
					expectation.fulfill()
				}
			}
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 2)

		XCTAssertFalse(viewModel.error.isEmpty, "Error should not be empty when fetching countries fails.")
	}

	func testRequestFindingPaddleSuccessfully() {
		let endpointReturnValue = RegistrationModel(status: "FOUND")
		let exp = expectation(description: "Sub view was changed successfully")
		let expLoading = getLoadingCycleExpectation()
		var methodLaunched = false

		mockPaddleRepository.findPaddlePublisher = Just(endpointReturnValue)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()

		viewModel.email = "test.user@example.com"

		viewModel.$subView
			.drop { _ in !methodLaunched }
			.sink { subView in
				switch subView {
				case let .userFound(model):
					XCTAssertEqual(model, endpointReturnValue)
					exp.fulfill()
				default:
					XCTFail("SubView did not change to .userFound as expected.")
				}
			}
			.store(in: &cancellables)

		methodLaunched = true
		viewModel.requestFindingPaddle()

		wait(for: [exp, expLoading], timeout: 2)
	}

	func testRequestFindingPaddleNotFound() {
		let endpointReturnValue = RegistrationModel(status: "NOT_FOUND")
		let exp = expectation(description: "Error value updated")
		let expLoading = getLoadingCycleExpectation()
		var methodLaunched = false

		mockPaddleRepository.findPaddlePublisher = Just(endpointReturnValue)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()

		viewModel.email = "test.user@example.com"

		viewModel.$error
			.drop { _ in !methodLaunched }
			.sink { message in
				XCTAssertEqual(message, String(localized: "paddle_label_paddleNotFound"))
				exp.fulfill()
			}
			.store(in: &cancellables)

		methodLaunched = true
		viewModel.requestFindingPaddle()

		wait(for: [exp, expLoading], timeout: 2)
	}

	func testRequestFindingPaddleFailure() {
		let error = URLError(.badServerResponse)
		let exp = expectation(description: "Error value updated")
		let expLoading = getLoadingCycleExpectation()
		var methodLaunched = false

		mockPaddleRepository.findPaddlePublisher = Fail(error: error).eraseToAnyPublisher()

		viewModel.email = "test.user@example.com"

		viewModel.$error
			.drop { _ in !methodLaunched }
			.sink { message in
				XCTAssertEqual(message, error.localizedDescription)
				exp.fulfill()
			}
			.store(in: &cancellables)

		methodLaunched = true
		viewModel.requestFindingPaddle()

		wait(for: [exp, expLoading], timeout: 2)
	}

	func testRequestFindingPaddlePassedIdentifier() {
		viewModel.email = "test.user@test.com"
		viewModel.phone = "123456789"

		viewModel.pickedMethod = .email
		viewModel.requestFindingPaddle()
		XCTAssertEqual(mockPaddleRepository.findPaddlePassedIdentifier,
		               viewModel.email)

		viewModel.pickedMethod = .cellPhone
		viewModel.requestFindingPaddle()
		XCTAssertEqual(mockPaddleRepository.findPaddlePassedIdentifier,
		               viewModel.phone)
	}

	func testConfirmFoundUserAlreadyCheckedIn() {
		let model = RegistrationModel(isCheckedIn: 1)
		let exp = expectation(description: "Sub view changed to .findPaddle")
		var methodLaunched = false

		viewModel.subView = .confirmInformation(model)

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case .findPaddle:
				exp.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.confirmFoundUser(model: model)

		wait(for: [exp], timeout: 2)
	}

	func testConfirmFoundUserWithoutPaddle() {
		let model = RegistrationModel(isCheckedIn: 0,
		                              currentPaddleNumber: nil)
		let exp = expectation(description: "Sub view changed to .findPaddle")
		var methodLaunched = false

		viewModel.subView = .confirmInformation(model)

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case .findPaddle:
				exp.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.confirmFoundUser(model: model)

		wait(for: [exp], timeout: 2)
	}

	func testConfirmFoundUserSuccessfully() {
		let model = RegistrationModel(isCheckedIn: 0,
		                              currentPaddleNumber: 123)

		let expSubView = expectation(description: "Sub view changed to .findPaddle")
		let expError = expectation(description: "Error is not added")
		let expLoading = getLoadingCycleExpectation()
		var methodLaunched = false

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case .findPaddle:
				expSubView.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		viewModel.$error.drop { _ in !methodLaunched }.sink { message in
			XCTAssertTrue(message.isEmpty)
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.confirmFoundUser(model: model)

		wait(for: [expSubView, expError, expLoading], timeout: 2)
	}

	func testConfirmFoundUserFailure() {
		let model = RegistrationModel(isCheckedIn: 0,
		                              currentPaddleNumber: 123)
		let error = URLError(.badServerResponse)
		mockPaddleRepository.checkInUserPublisher = Fail(error: error).eraseToAnyPublisher()

		let expSubView = expectation(description: "Sub view changed to .findPaddle")
		let expError = expectation(description: "Error is added")
		let expLoading = getLoadingCycleExpectation()
		var methodLaunched = false

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case .findPaddle:
				expSubView.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		viewModel.$error.drop { _ in !methodLaunched }.sink { message in
			XCTAssertEqual(message, error.localizedDescription)
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.confirmFoundUser(model: model)

		wait(for: [expSubView, expError, expLoading], timeout: 2)
	}

	private func setUpViewModelForRegistration() {
		viewModel.subView = .createAccount

		viewModel.firstName = "Test"
		viewModel.lastName = "User"
		viewModel.email = "test.user@test.com"
		viewModel.phone = "123456789"
		viewModel.countryCode = "US"
	}

	func testRegisterNewUserMissingFirstName() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false

		setUpViewModelForRegistration()
		viewModel.firstName = ""

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, String(localized: "paddle_hint_emptyName"))
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserMissingLastName() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false

		setUpViewModelForRegistration()
		viewModel.lastName = ""

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, String(localized: "paddle_hint_emptyName"))
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserMissingEmail() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false

		setUpViewModelForRegistration()
		viewModel.email = ""

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, String(localized: "paddle_hint_incorrectEmail"))
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserMissingPhone() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false

		setUpViewModelForRegistration()
		viewModel.phone = ""

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, String(localized: "paddle_hint_emptyPhone"))
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserFailure() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false
		let error = URLError(.badServerResponse)

		setUpViewModelForRegistration()
		mockPaddleRepository.registerUserError = error

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, error.localizedDescription)
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserNoSuccessWithErrorMessage() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false
		let response = RegistrationModel(success: false, errorMessage: "Test error")

		setUpViewModelForRegistration()
		mockPaddleRepository.registerUserReturnedValue = response

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, response.errorMessage)
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserNoSuccessWithoutErrorMessage() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is added")
		var methodLaunched = false
		let response = RegistrationModel(success: false)

		setUpViewModelForRegistration()
		mockPaddleRepository.registerUserReturnedValue = response

		viewModel.$error.drop { m in !methodLaunched || m.isEmpty }.sink { message in
			XCTAssertEqual(message, String(localized: "global_label_unknownError"))
			expError.fulfill()
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError], timeout: 2)

		switch viewModel.subView {
		case .createAccount:
			break
		default:
			XCTFail()
		}
	}

	func testRegisterNewUserSuccessfully() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is not added")
		let expSubView = expectation(description: "Sub view is changed to .confirmInformation")
		var methodLaunched = false
		let response = RegistrationModel(status: "New-Registration Succeeded",
		                                 success: true)

		setUpViewModelForRegistration()
		mockPaddleRepository.registerUserReturnedValue = response

		viewModel.$error.drop { _ in !methodLaunched }.sink { message in
			XCTAssertTrue(message.isEmpty)
			expError.fulfill()
		}.store(in: &cancellables)

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case let .confirmInformation(model):
				XCTAssertEqual(model, response)
				expSubView.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError, expSubView], timeout: 2)
	}

	func testRegisterNewUserAlreadyExists() {
		let expLoading = getLoadingCycleExpectation()
		let expError = expectation(description: "Error is not added")
		let expSubView = expectation(description: "Sub view is changed to .userFound")
		var methodLaunched = false
		let response = RegistrationModel(status: "New-Registration Duplicate",
		                                 success: true)

		setUpViewModelForRegistration()
		mockPaddleRepository.registerUserReturnedValue = response

		viewModel.$error.drop { _ in !methodLaunched }.sink { message in
			XCTAssertTrue(message.isEmpty)
			expError.fulfill()
		}.store(in: &cancellables)

		viewModel.$subView.drop { _ in !methodLaunched }.sink { subView in
			switch subView {
			case let .userFound(model):
				XCTAssertEqual(model, response)
				expSubView.fulfill()
			default:
				XCTFail()
			}
		}.store(in: &cancellables)

		methodLaunched = true
		viewModel.registerNewUser()

		wait(for: [expLoading, expError, expSubView], timeout: 2)
	}
}
