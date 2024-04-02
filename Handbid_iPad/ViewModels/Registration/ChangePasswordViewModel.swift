// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ChangePasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
	@Published var errorMessage: String = ""
	@Published var password: String = ""
	@Published var confirmPassword: String = ""
	@Published var isCorrectPassword: Bool = true

	func validatePassword() {
		let isPasswordValid = password.isPasswordSecure()
		let passwordsMatch = (confirmPassword == password)

		if !isPasswordValid {
			errorMessage = "Password does not meet security requirements"
			isCorrectPassword = false
		}
		else if !passwordsMatch {
			errorMessage = "Passwords do not match"
			isCorrectPassword = false
		}
		else {
			isCorrectPassword = true
		}
	}

	func resetErrorMessage() {
		password = ""
		confirmPassword = ""
		errorMessage = ""
	}
}
