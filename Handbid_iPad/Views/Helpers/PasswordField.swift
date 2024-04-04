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
				.applyTextStyle(style: .formHeader)
				.frame(height: 15)

			ZStack(alignment: .trailing) {
				if isPasswordShown {
					TextField(hintKey, text: $fieldValue)
						.applyTextFieldStyle(style: .form)
				}
				else {
					SecureField(hintKey, text: $fieldValue)
						.applySecuredFieldStyle(style: .formField)
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
