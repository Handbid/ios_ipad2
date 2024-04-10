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
	@Published var isScrollViewEnabled: Bool = true

	init(repository: RegisterRepository, authManager: AuthManager) {
		self.repository = repository
		self.authManager = authManager
	}

	func logIn() {
		if !email.isValidEmail() {
			errorMessage = NSLocalizedString("registration_label_incorrectEmail", comment: "Incorrect Email Format")
			isFormValid = false
			return
		}
		else if !password.isPasswordSecure() {
			errorMessage = NSLocalizedString("registration_label_passwordRequirements", comment: "Password doesn't meet the requirements")
			isFormValid = false
			return
		}
		else {
			isFormValid = true
		}

		Task {
			var authResponse: AuthModel
			do {
				authResponse = try await repository.logIn(username: self.email, password: self.password, pin: nil)
				print(authResponse)
			}
			catch {
				DispatchQueue.safeMainAsync {
					self.errorMessage = NSLocalizedString("login_label_incorrectCredentials", comment: "Incorrect email or password")
					self.isFormValid = false
				}
				return
			}

			let authData = await self.authManager.loginWithAuthModel(auth: authResponse)

			if authData {
				print("Login successful")
				let saveData = await self.authManager.loginWithAuthModel(auth: authResponse)
				if saveData {
					print("Data is saved")
					NotificationCenter.default.post(name: .userLoggedIn, object: nil)
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
