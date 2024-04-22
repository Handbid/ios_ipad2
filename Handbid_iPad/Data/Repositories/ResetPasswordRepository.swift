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
		let params: Params = ["identifier": email,
		                      "whitelabelId": AppInfoProvider.whitelabelId]

		return get(ApiEndpoints.resetPassword, params: params)
			.tryMap { try ResetPasswordModel.decode($0) }
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}
}
