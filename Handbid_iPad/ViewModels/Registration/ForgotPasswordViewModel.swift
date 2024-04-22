// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import NetworkService

class ForgotPasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ResetPasswordRepository
	@Published var isFormValid = true
	@Published var email: String = ""
	@Published var errorMessage: String = ""
	@Published var requestStatus: NetworkingError.Status?

	init(repository: ResetPasswordRepository) {
		self.repository = repository
	}

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
					if let netError = error as? NetworkingError {
						self.requestStatus = netError.status
						self.errorMessage = "\(error)"
					}
				}
			}, receiveValue: { response in
				print(response)
				self.requestStatus = response.success == true ? .ok : .badRequest

				if self.requestStatus == .badRequest {
					self.errorMessage = response.message ?? String(localized: LocalizedStringResource("global_label_unknownError"))
				}
			}).store(in: &cancellables)
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}
