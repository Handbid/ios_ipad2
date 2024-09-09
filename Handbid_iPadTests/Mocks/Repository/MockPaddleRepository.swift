// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockPaddleRepository: PaddleRepository {
	func findPaddle(identifier _: String, auctionId _: Int) -> AnyPublisher<RegistrationModel, any Error> {
		Just(RegistrationModel())
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}

	func checkInUser(paddleNumber _: Int, auctionId _: Int) -> AnyPublisher<RegistrationModel, any Error> {
		Just(RegistrationModel())
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}

	func registerUser(firstName _: String, lastName _: String, phoneNumber _: String, countryCode _: String, email _: String, auctionGuid _: String) async throws -> RegistrationModel {
		RegistrationModel()
	}
}
