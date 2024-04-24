// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	@Published var searchOrganization: String = ""
	@Published var environmentOptions: [AppEnvironmentType] = [.prod, .d1, .d2, .d3, .qa]
	@Published var filteredOptions: [AppEnvironmentType] = []
	@Published var selectedOption: AppEnvironmentType?

	init() {
		self.selectedOption = AppEnvironmentType.currentState
		setupSubscriptions()
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
