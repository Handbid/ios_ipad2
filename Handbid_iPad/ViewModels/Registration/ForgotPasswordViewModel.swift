// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ForgotPasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: ResetPasswordRepository
	@Published var isFormValid = true
	@Published var email: String = ""
	@Published var errorMessage: String = ""
	@Published var requestStatus: RequestStatus = .noResult

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
					self.requestStatus = .failed
					self.errorMessage = "\(error)"
				}
			}, receiveValue: { response in
				print(response)
				self.requestStatus = response.success == true ? .successful : .failed

				if self.requestStatus == .failed {
					self.errorMessage = response.message ?? String(localized: LocalizedStringResource("global_label_unknownError"))
				}
			}).store(in: &cancellables)
	}

	func resetErrorMessage() {
		errorMessage = ""
	}
}

enum RequestStatus {
	case noResult, successful, failed
}
