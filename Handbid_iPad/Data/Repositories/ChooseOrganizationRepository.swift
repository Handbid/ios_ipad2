// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol ChooseOrganizationRepository {
	func fetchUserOrganizations() -> AnyPublisher<UserModel, Error>
}

class ChooseOrganizationRepositoryImpl: ChooseOrganizationRepository, NetworkingService {
	var network: NetworkService.NetworkingClient
	let modelContext: ModelContext
	@Published var user: UserModel = .init()

	init(_ network: NetworkService.NetworkingClient, modelContext: ModelContext) {
		self.network = network
		self.modelContext = modelContext
	}

	func fetchUserOrganizations() -> AnyPublisher<UserModel, Error> {
		post(ApiEndpoints.auctionUser)
			.tryMap { try UserModel.decode($0) }
			.receive(on: DispatchQueue.main)
			.handleEvents(receiveOutput: { [weak self] user in
				self?.user = user
				self?.saveOrUpdateUser(user: user)
			})
			.eraseToAnyPublisher()
	}

	private func saveOrUpdateUser(user _: UserModel) {
		do {
			try modelContext.save(user)
		}
		catch {
			print("Failed to save user: \(error)")
		}
	}
}
