// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService

class ResetPasswordViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()
	private var repository: RegisterRepository = RegisterRepositoryImpl(NetworkingClient())
	@Published var errorMessage: String = ""
	@Published var isPinValid = false
	@Published var pin: String = ""

	func validatePin() {
		if !pin.isValidPin() {
			errorMessage = "Incorrect Pin Format"
			isPinValid = false
			return
		}
		isPinValid = true
	}

	func resetErrorMessage() {
		pin = ""
		errorMessage = ""
		isPinValid = true
	}
}
