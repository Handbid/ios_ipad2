// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChooseEnvironmentViewModel: ObservableObject, NetworkingService {
	var network: NetworkService.NetworkingClient
	private var cancellables = Set<AnyCancellable>()
	@Published var email: String = ""
	@Published var environmentOptions: [AppEnvironmentType] = [.prod, .d1, .d2, .d3, .qa]
	@Published var selectedOption: AppEnvironmentType?

	init(_ network: NetworkService.NetworkingClient) {
		self.selectedOption = AppEnvironmentType.currentState
		self.network = network
	}

	func saveEnvironment() {
		EnvironmentManager.setEnvironment(for: selectedOption ?? .prod)
	}
}
