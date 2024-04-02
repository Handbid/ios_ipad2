// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
    private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
    private var authManager: AuthManager = AuthManager()

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

        repository.logIn(email: email, password: password, pin: nil)
             .sink(receiveCompletion: { completion in
             }, receiveValue: { response in
                 Task {
                     guard let authData = response as? AuthModel else { return }
                     let success = await self.authManager.loginWithAuthModel(auth: authData)
        
                     print(response)
                 }
             })
             .store(in: &cancellables)
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
