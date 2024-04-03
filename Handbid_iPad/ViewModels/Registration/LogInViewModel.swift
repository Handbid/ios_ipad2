// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
	private var authManager: AuthManager = .init()

	@Published var email: String = ""
	@Published var password: String = ""
	@Published var isFormValid = true
	@Published var errorMessage: String = ""
	@Published var showError: Bool = false

	func logIn() {
		if !email.isValidEmail() {
			errorMessage = "Incorrect Email Format"
			isFormValid = false
			return
		}
		else if !password.isPasswordSecure() {
			errorMessage = "Password Not Meet Requirements"
			isFormValid = false
			return
		}
		else {
			isFormValid = true
		}

		repository.getReCaptchaToken()
			.sink(receiveCompletion: { _ in

			}, receiveValue: { token in

				/// auth
				AuthModel().signIn(username: self.email, password: self.password, pin: nil, captchaToken: token)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .finished:
							break
						case let .failure(error):
							print("Error fetching app version: \(error)")
						}
					}, receiveValue: { receieData in
						Task {
							let authData = await self.authManager.loginWithAuthModel(auth: receieData as AuthModel)

							if authData {
								print("Login successful")
								let saveData = await self.authManager.loginWithAuthModel(auth: receieData)
								if saveData {
									print("Data is saved")
								}
							}
							else {
								print("Login failed")
							}
						}
					}).store(in: &self.cancellables)
			})
			.store(in: &cancellables)
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
