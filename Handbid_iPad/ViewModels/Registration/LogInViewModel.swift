// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
	var login: String = ""
	var password: String = ""

	func fetchAppVersion() {
		repository.getAppVersion()
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

	func logIn() {
		repository.logIn(email: login, password: password)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					print("Error logging in: \(error)")
				}
			}, receiveValue: { response in
				print(response)
			})
			.store(in: &cancellables)
	}
}
