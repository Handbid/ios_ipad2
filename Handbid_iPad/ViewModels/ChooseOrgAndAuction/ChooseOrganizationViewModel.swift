// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseOrganizationViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	@Published var searchOrganization: String = ""
	@Published var environmentOptions: [AppEnvironmentType] = [.prod, .d1, .d2, .d3, .qa]
	@Published var selectedOption: AppEnvironmentType?

	init() {
		self.selectedOption = AppEnvironmentType.currentState
	}

	func saveEnvironment() {
		EnvironmentManager.setEnvironment(for: selectedOption ?? .prod)
	}
}
