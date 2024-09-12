// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockPaddleRepository: PaddleRepository {
	var findPaddlePublisher = Just(RegistrationModel())
		.setFailureType(to: Error.self)
		.eraseToAnyPublisher()

	var checkInUserPublisher = Just(RegistrationModel())
		.setFailureType(to: Error.self)
		.eraseToAnyPublisher()

	var registerUserReturnedValue = RegistrationModel()
	var registerUserError: Error? = nil

	var findPaddlePassedIdentifier = ""

	func findPaddle(identifier: String, auctionId _: Int) -> AnyPublisher<RegistrationModel, any Error> {
		findPaddlePassedIdentifier = identifier
		return findPaddlePublisher
	}

	func checkInUser(paddleNumber _: Int, auctionId _: Int) -> AnyPublisher<RegistrationModel, any Error> {
		checkInUserPublisher
	}

	func registerUser(firstName _: String, lastName _: String, phoneNumber _: String, countryCode _: String, email _: String, auctionGuid _: String) async throws -> RegistrationModel {
		if let error = registerUserError { throw error }
		return registerUserReturnedValue
	}
}
