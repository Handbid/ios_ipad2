// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ChooseOrganizationRepository
	@Published var searchOrganization: String = ""
	@Published var organizations: [OrganizationModel] = []
	@Published var filteredOrganizations: [OrganizationModel] = []
	@Published var selectedOrganization: OrganizationModel?

	init(repository: ChooseOrganizationRepository) {
		self.repository = repository
		setupSubscriptions()
	}

	func fetchOrganizationsIfNeeded() {
		guard organizations.isEmpty else { return }
		fetchOrganizations()
	}

	private func fetchOrganizations() {
		repository.fetchUserOrganizations()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					if let netError = error as? NetworkingError {
						print(netError)
					}
				}
			}, receiveValue: { user in
				guard let orgs = user.organization else { return }
				self.organizations = orgs
				self.filteredOrganizations = self.filterOrganizations(with: self.searchOrganization)
			})
			.store(in: &cancellables)
	}

	private func filterOrganizations(with searchText: String) -> [OrganizationModel] {
		if searchText.isEmpty {
			organizations
		}
		else {
			organizations.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
		}
	}

	private func setupSubscriptions() {
		$searchOrganization
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.removeDuplicates()
			.map { [unowned self] searchText in
				filterOrganizations(with: searchText)
			}
			.assign(to: \.filteredOrganizations, on: self)
			.store(in: &cancellables)
	}
}
