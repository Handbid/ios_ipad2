// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private let repository: ChooseOrganizationRepository
	private let dataManager: DataManager

	@Published var organizations: [OrganizationModel] = []
	@Published var filteredOrganizations: [OrganizationModel] = []
	@Published var selectedOrganization: OrganizationModel?
	@Published var searchOrganization: String = "" {
		didSet {
			filterOrganizations()
		}
	}

	init(repository: ChooseOrganizationRepository, dataManager: DataManager) {
		self.repository = repository
		self.dataManager = dataManager
		setupSearchOrganizationSubscriber()
	}

	func fetchOrganizationsIfNeeded() {
		guard organizations.isEmpty else { return }
		fetchOrganizations()
	}

	private func fetchOrganizations() {
		repository.fetchUserOrganizations()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: handleCompletion, receiveValue: handleOrganizationsReceived)
			.store(in: &cancellables)
	}

	private func filterOrganizations() {
		filteredOrganizations = searchOrganization.isEmpty ? organizations : organizations.filter { $0.name?.localizedCaseInsensitiveContains(searchOrganization) == true }
	}

	private func setupSearchOrganizationSubscriber() {
		$searchOrganization
			.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
			.sink { [weak self] _ in
				self?.filterOrganizations()
			}
			.store(in: &cancellables)
	}

	private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
		if case let .failure(error) = completion, let netError = error as? NetworkingError {
			print(netError)
		}
	}

	private func handleOrganizationsReceived(_ user: UserModel) {
		organizations = user.organization ?? []

		do {
			try? dataManager.create(user, in: .user)
		}

		let user2: UserModel? = try? dataManager.fetchSingle(of: UserModel.self, from: .user)
		print(user2?.identity)

		do {
			try? dataManager.update(user, withNestedUpdates: true, in: .user)

			let user2: UserModel? = try? dataManager.fetchSingle(of: UserModel.self, from: .user)
			print(user2?.identity)
		}

		try? dataManager.deleteAll(of: UserModel.self, from: .user)

		filterOrganizations()
	}
}
