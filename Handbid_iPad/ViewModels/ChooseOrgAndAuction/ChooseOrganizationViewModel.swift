// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ChooseOrganizationRepository
	@Published var searchOrganization: String = ""
	@Published var environmentOptions: [AppEnvironmentType] = [.prod, .d1, .d2, .d3, .qa]
	@Published var filteredOptions: [AppEnvironmentType] = []
	@Published var selectedOption: AppEnvironmentType?

	init(repository: ChooseOrganizationRepository) {
		self.repository = repository
		self.selectedOption = AppEnvironmentType.currentState
		setupSubscriptions()
		requestPasswordReset()
	}

	func requestPasswordReset() {
		repository.fetchUserOrganization()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					if let netError = error as? NetworkingError {
						print(netError)
						//                        self.requestStatus = netError.status
						//                        self.errorMessage = "\(error)"
					}
				}
			}, receiveValue: { response in
				print(response)
				// self.requestStatus = response.success == true ? .ok : .badRequest

				//                if self.requestStatus == .badRequest {
				//                    self.errorMessage = response.message ?? String(localized: LocalizedStringResource("global_label_unknownError"))
				//                }
			}).store(in: &cancellables)
	}

	func setupSubscriptions() {
		$searchOrganization
			.receive(on: RunLoop.main)
			.map { [unowned self] searchText in
				filterOptions(with: searchText)
			}
			.assign(to: \.filteredOptions, on: self)
			.store(in: &cancellables)
	}

	private func filterOptions(with searchText: String) -> [AppEnvironmentType] {
		if searchText.isEmpty {
			environmentOptions
		}
		else {
			environmentOptions.filter { $0.rawValue.lowercased().contains(searchText.lowercased()) }
		}
	}
}
