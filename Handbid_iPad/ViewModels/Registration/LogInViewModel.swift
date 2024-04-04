// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
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

		Task {
			var authResponse: AuthModel
			/// auth
			do {
				authResponse = try await repository.logIn(username: self.email, password: self.password, pin: nil)
			}
			catch {
				print("Error logging in: \(error)")
				return
			}

			let authData = await self.authManager.loginWithAuthModel(auth: authResponse)

			if authData {
				print("Login successful")
				let saveData = await self.authManager.loginWithAuthModel(auth: authResponse)
				if saveData {
					print("Data is saved")
				}
			}
			else {
				print("Login failed")
			}
		}
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
