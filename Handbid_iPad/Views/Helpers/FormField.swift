// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FormField: View {
	@Binding var fieldValue: String
	var labelKey: LocalizedStringKey
	var hintKey: LocalizedStringKey

	var body: some View {
		VStack(alignment: .leading) {
			Text(labelKey)
				.textFieldLabelStyle()

			TextField(hintKey, text: $fieldValue)
				.basicTextFieldStyle()
		}
	}
}
