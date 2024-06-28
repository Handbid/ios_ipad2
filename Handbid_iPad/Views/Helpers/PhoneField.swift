// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PhoneField: View {
	var labelKey: LocalizedStringKey? = nil
	var hintKey: LocalizedStringKey
	let countryCodes: [String]
	@Binding var selectedCountryCode: String
	@Binding var fieldValue: String

	var body: some View {
		VStack {
			if let key = labelKey {
				Text(key)
					.applyTextStyle(style: .formHeader)
					.frame(height: 15)
					.padding(.leading, -15)
			}

			HStack {
				Picker("Country code",
				       selection: $selectedCountryCode)
				{
					ForEach(countryCodes, id: \.self) { code in
						Text(code).tag(code)
					}
				}
				.pickerStyle(.menu)
				.frame(height: 54)
				.background {
					RoundedRectangle(cornerRadius: 8)
						.stroke(.hbGray, lineWidth: 1)
				}

				TextField(hintKey,
				          text: $fieldValue)
					.applyTextFieldStyle(style: .form)
					.keyboardType(.phonePad)
					.textContentType(.telephoneNumber)
			}
		}
	}
}
