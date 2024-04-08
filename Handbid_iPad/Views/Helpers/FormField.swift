// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FormField: View {
	@Binding var fieldValue: String
	var labelKey: LocalizedStringKey
	var hintKey: LocalizedStringKey
	@State private var isEditing = false

	var body: some View {
		VStack(alignment: .leading) {
			Text(labelKey)
				.applyTextStyle(style: .formHeader)
				.frame(height: 15)

			TextField(hintKey, text: $fieldValue, onEditingChanged: { editing in
				isEditing = editing
			})
			.applyTextFieldStyle(style: .form)
		}
	}
}
