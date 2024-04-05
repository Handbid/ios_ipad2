// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

protocol LogInViewModelProtocol {
	var email: String { get set }
	var password: String { get set }
	var isFormValid: Bool { get }
	var errorMessage: String { get }
	var showError: Bool { get }

	func logIn()
	func resetErrorMessage()
}

class LogInViewModel: ObservableObject, LogInViewModelProtocol {
	private var repository: RegisterRepository
	private var authManager: AuthManager

	@Published var email: String = ""
	@Published var password: String = ""
	@Published var isFormValid = true
	@Published var errorMessage: String = ""
	@Published var showError: Bool = false

	init(repository: RegisterRepository, authManager: AuthManager) {
		self.repository = repository
		self.authManager = authManager
	}

	func logIn() {
		if !email.isValidEmail() {
			errorMessage = "Incorrect Email Format"
			isFormValid = false
			return
		}
		else if !password.isPasswordSecure() {
			errorMessage = "Password Does Not Meet Requirements"
			isFormValid = false
			return
		}
		else {
			isFormValid = true
		}

		Task {
			do {
				let authResponse = try await repository.logIn(username: email, password: password, pin: nil)
				let authData = await authManager.loginWithAuthModel(auth: authResponse)

				if authData {
					print("Login successful")
					let saveData = await authManager.loginWithAuthModel(auth: authResponse)
					if saveData {
						print("Data is saved")
					}
				}
				else {
					print("Login failed")
				}
			}
			catch {
				print("Error logging in: \(error)")
			}
		}
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
