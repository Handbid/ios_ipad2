// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

protocol ChooseOrganizationRepository {
	func fetchUserOrganizations() -> AnyPublisher<UserModel, Error>
}

class ChooseOrganizationRepositoryImpl: ChooseOrganizationRepository, NetworkingService {
	var network: NetworkService.NetworkingClient
	@Published var user: UserModel = .init()

	let modelContainer = ModelContainer()
	let modelContext: ModelContext

	init(_ network: NetworkService.NetworkingClient) {
		self.network = network
		self.modelContext = ModelContext(modelContainer)
	}

	func fetchUserOrganizations() -> AnyPublisher<UserModel, Error> {
		post(ApiEndpoints.auctionUser)
			.tryMap { try UserModel.decode($0) }
			.receive(on: DispatchQueue.main)
			.handleEvents(receiveOutput: { [weak self] user in
				self?.user = user
				self?.saveUserModel(user)
			})
			.eraseToAnyPublisher()
	}

	private func saveUserModel(_ user: UserModel) {
		do {
			try modelContext.save(user)
			print("User saved with success")
		}
		catch {
			print("User not saved data")
		}
	}
}
