// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI

enum Field: Hashable {
	case email, password
}

struct FormField: View {
	let fieldType: Field

	var labelKey: LocalizedStringKey
	var hintKey: LocalizedStringKey
	@Binding var fieldValue: String
	@FocusState var focusedField: Field?
	@State var isPasswordShown = false

	var body: some View {
		switch fieldType {
		case .email:
			Text(labelKey)
				.applyTextStyle(style: .formHeader)
				.frame(height: 15)
				.padding(.leading, -15)
			TextField(hintKey, text: $fieldValue)
				.applyTextFieldStyle(style: .form)
				.keyboardType(.emailAddress)
				.textContentType(.emailAddress)
				.focused($focusedField, equals: .email)
				.id(Field.email)
				.onTapGesture {}
		case .password:
			Text(labelKey)
				.applyTextStyle(style: .formHeader)
				.frame(height: 15)
				.padding(.leading, -15)

			ZStack(alignment: .trailing) {
				if isPasswordShown {
					TextField(hintKey, text: $fieldValue)
						.applyTextFieldStyle(style: .form)
						.textContentType(.password)
						.focused($focusedField, equals: .password)
						.id(Field.password)
						.onTapGesture {}
				}
				else {
					SecureField(hintKey, text: $fieldValue)
						.applySecuredFieldStyle(style: .formField)
						.textContentType(.password)
						.focused($focusedField, equals: .password)
						.id(Field.password)
						.onTapGesture {}
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
