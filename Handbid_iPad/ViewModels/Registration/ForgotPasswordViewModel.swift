// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ForgotPasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
	@Published var isFormValid = true
	@Published var email: String = ""
	@Published var errorMessage: String = ""

	func valideEmail() {
		if !email.isValidEmail() {
			errorMessage = "Incorrect Email Format"
			isFormValid = false
			return
		}
		isFormValid = true
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
