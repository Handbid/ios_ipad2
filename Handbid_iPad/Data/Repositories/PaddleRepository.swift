// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

enum SearchBy: String, CaseIterable {
	case email, cellPhone

	func getLocalizedLabel() -> LocalizedStringKey {
		switch self {
		case .cellPhone:
			LocalizedStringKey("global_label_cellPhone")
		case .email:
			LocalizedStringKey("global_label_email")
		}
	}
}

protocol PaddleRepository {
	func findPaddle(identifier: String, auctionId: Int) -> AnyPublisher<RegistrationModel, Error>
	func checkInUser(paddleNumber: String, auctionId: Int) -> AnyPublisher<RegistrationModel, Error>
	func registerUser(firstName: String,
	                  lastName: String,
	                  phoneNumber: String,
	                  countryCode: String,
	                  email: String) async throws -> RegistrationModel
}

class PaddleRepositoryImpl: PaddleRepository, NetworkingService {
	var network: NetworkService.NetworkingClient
    private let reCaptchaRepository: ReCaptchaRepository

	init(network: NetworkService.NetworkingClient) {
		self.network = network
        self.reCaptchaRepository = ReCaptchaRepository()
	}

	func findPaddle(identifier: String, auctionId: Int) -> AnyPublisher<RegistrationModel, any Error> {
		get(ApiEndpoints.findPaddle, params: ["identifier": identifier,
		                                      "auctionId": auctionId])
			.tryMap { try RegistrationModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}

	func checkInUser(paddleNumber: String, auctionId: Int) -> AnyPublisher<RegistrationModel, any Error> {
		get(ApiEndpoints.checkInUser, params: ["paddleNumber": paddleNumber,
		                                       "auctionId": auctionId])
			.tryMap { try RegistrationModel.decode($0) }
			.map { $0 }
			.eraseToAnyPublisher()
	}

    func registerUser(firstName: String, lastName: String, phoneNumber: String, countryCode: String, email: String) async throws -> RegistrationModel {
        
        
        let recaptchaToken = try await reCaptchaRepository.getReCaptchaToken()
        
        return try await get(ApiEndpoints.registerUser, params: ["firstName": firstName,
                                                       "lastName": lastName,
                                                       "mobile": phoneNumber,
                                                       "email": email,
                                                       "countryCode": countryCode,
                                                       "recaptchaToken": recaptchaToken])
        .tryMap { try RegistrationModel.decode($0) }
        .map { $0 }
        .eraseToAnyPublisher()
        .async()
    }
	
}
