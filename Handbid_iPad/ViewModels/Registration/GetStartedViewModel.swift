// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class GetStartedViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: LogInAnonymously = RegisterRepositoryImpl(NetworkingClient())

	func openHandbidWebsite() {
		if let url = URL(string: AppInfoProvider.aboutHandbidLink) {
			UIApplication.shared.open(url)
		}
	}

	func logInAnonymously() {
		repository.logInAnonymously()
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
