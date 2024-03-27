// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	var login: String = ""
	var password: String = ""

	func fetchAppVersion() {
		AppVersionModel().fetchAppVersion()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					print("Error fetching app version: \(error)")
				}
			}, receiveValue: { version in
				print(version)
			})
			.store(in: &cancellables)
	}
}
