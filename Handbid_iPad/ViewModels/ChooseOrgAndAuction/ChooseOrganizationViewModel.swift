// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ChooseOrganizationRepository
    @Published var organizations: [OrganizationModel] = []
    @Published var filteredOrganizations: [OrganizationModel] = []
    @Published var selectedOrganization: OrganizationModel?
	@Published var searchOrganization: String = "" {
		didSet {
			filterOrganizations()
		}
	}

	init(repository: ChooseOrganizationRepository) {
		self.repository = repository
		setupSearchOrganizationSubscriber()
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
			}, receiveValue: { [weak self] user in
				self?.organizations = user.organization ?? []
				self?.filterOrganizations()
			})
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
}
