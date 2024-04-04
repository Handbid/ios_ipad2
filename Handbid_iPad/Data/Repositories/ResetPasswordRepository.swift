// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

protocol ResetPasswordRepository {
	func resetPassword(email: String) -> AnyPublisher<ResetPasswordModel, Error>
}

class ResetPasswordRepositoryImpl: ResetPasswordRepository, NetworkingService {
	var network: NetworkService.NetworkingClient

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
	}

	func resetPassword(email: String) -> AnyPublisher<ResetPasswordModel, Error> {
		get(ApiEndpoints.resetPassword, params: ["identifier": email,
		                                         "whitelabelId": AppInfoProvider.whitelabelId])
			.tryMap { try ResetPasswordModel.decode($0) }
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}
}
