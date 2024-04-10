// Copyright (c) 2024 by Handbid. All rights reserved.

extension String {
	func isValidEmail() -> Bool {
		let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return emailPredicate.evaluate(with: self)
	}

	func isPasswordSecure() -> Bool {
		let minPasswordLength = 8
		return count >= minPasswordLength
	}

	func isValidPin() -> Bool {
		let pinRegex = #"^\d{4}$"#
		let pinPredicate = NSPredicate(format: "SELF MATCHES %@", pinRegex)
		return pinPredicate.evaluate(with: self)
	}
}
