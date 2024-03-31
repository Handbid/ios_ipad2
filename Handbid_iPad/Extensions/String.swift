// Copyright (c) 2024 by Handbid. All rights reserved.

extension String {
	func isValidEmail() -> Bool {
		let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return emailPredicate.evaluate(with: self)
	}

	func isPasswordSecure() -> Bool {
		let minPasswordLength = 8
		let uppercaseLetterCharacterSet = CharacterSet.uppercaseLetters
		let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=~`|/.,:;<>[]{}")

		return count >= minPasswordLength &&
			rangeOfCharacter(from: uppercaseLetterCharacterSet) != nil &&
			rangeOfCharacter(from: specialCharacterSet) != nil
	}
}
