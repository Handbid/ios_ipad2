// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PasswordField: View {
	@Binding var fieldValue: String
	var labelKey: LocalizedStringKey
	var hintKey: LocalizedStringKey
	@State var isPasswordShown = false

	var body: some View {
		VStack(alignment: .leading) {
			Text(labelKey)
				.textFieldLabelStyle()

			ZStack(alignment: .trailing) {
				if isPasswordShown {
					TextField(hintKey, text: $fieldValue)
						.basicTextFieldStyle()
				}
				else {
					SecureField(hintKey, text: $fieldValue)
						.basicTextFieldStyle()
				}

				Image(isPasswordShown ? "EyeIconCrossed" : "EyeIcon")
					.padding()
					.onTapGesture {
						isPasswordShown = !isPasswordShown
					}
			}
		}
	}
}
