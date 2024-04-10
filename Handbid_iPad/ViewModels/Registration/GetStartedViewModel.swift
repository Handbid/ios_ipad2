// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class GetStartedViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private let repository: LogInAnonymously

	init(repository: LogInAnonymously) {
		self.repository = repository
	}

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
					print("Error logging in anonymously: \(error)")
				}
			}, receiveValue: { version in
				print(version)
			})
			.store(in: &cancellables)
	}
}
