// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())

	@Published var email: String = ""
	@Published var password: String = ""
	@Published var isFormValid = true

	@Published var errorMessage: String = ""

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

	func logIn(email: String, password: String) {
		if !email.isValidEmail() {
			errorMessage = "Incorrect Email Format"
			isFormValid = false
			return
		} else if !password.isPasswordSecure() {
			errorMessage = "Password Not Meet Requirements"
			isFormValid = false
			return
		} else {
			isFormValid = true
		}

		repository.logIn(email: email, password: password)
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

	func resetErrorMessage() {
		errorMessage = ""
	}
}
