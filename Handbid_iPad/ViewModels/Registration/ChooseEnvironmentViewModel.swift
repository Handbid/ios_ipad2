// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseEnvironmentViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	@Published var email: String = ""
	@Published var environmentOptions: [AppEnvironmentType] = [.prod, .d1, .d2, .d3, .qa]
	@Published var selectedOption: AppEnvironmentType?

	init() {
		self.selectedOption = AppEnvironmentType.currentState
	}

	func saveEnvironment() {
		guard let selectedOption else { return }
		EnvironmentManager.setEnvironment(for: selectedOption)
	}
}
