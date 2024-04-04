// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ForgotPasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ResetPasswordRepository = ResetPasswordRepositoryImpl(NetworkingClient())
	@Published var isFormValid = true
	@Published var email: String = ""
	@Published var errorMessage: String = ""
	@Published var isSuccessfulRequest = false

	func validateEmail() {
		if !email.isValidEmail() {
			errorMessage = "Incorrect Email Format"
			isFormValid = false
			return
		}
		isFormValid = true
	}

	func requestPasswordReset() {
		repository.resetPassword(email: email)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					self.errorMessage = "\(error)"
				}
			}, receiveValue: { response in
				print(response)
				self.isSuccessfulRequest = response.success ?? false

				if !self.isSuccessfulRequest {
					self.errorMessage = response.message ?? String(localized: LocalizedStringResource("global_label_unknownError"))
				}
			}).store(in: &cancellables)
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
