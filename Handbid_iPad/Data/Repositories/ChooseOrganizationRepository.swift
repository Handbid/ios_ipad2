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
				self?.saveOrUpdateUser(user: user)
			})
			.eraseToAnyPublisher()
	}

	func saveOrUpdateUser(user: UserModel) {
		if let existingUser = modelContext.model(for: user.usersGuid ?? "") as UserModel? {
			do {
				// If exists, try to update
				try modelContext.update(user)
				print("User updated successfully")
			}
			catch {
				print("Failed to update user: \(error)")
			}
		}
		else {
			do {
				// If not exists, try to save as new
				try modelContext.save(user)
				print("User saved successfully")
			}
			catch {
				print("Failed to save user: \(error)")
			}
		}
	}
}
