// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI

enum Field: Hashable {
	case email, firstName, lastName, password, searchBar, searchBarItems
}

struct FormField: View {
	let fieldType: Field

	var labelKey: LocalizedStringKey
	var hintKey: LocalizedStringKey
	@Binding var fieldValue: String
	@FocusState var focusedField: Field?
	@State var isPasswordShown = false
	@State private var isEditing = false
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		switch fieldType {
		case .email, .firstName, .lastName:
			VStack {
				Text(labelKey)
					.applyTextStyle(style: .formHeader)
					.frame(height: 15)
					.padding(.leading, -15)
				TextField(hintKey, text: $fieldValue)
					.applyTextFieldStyle(style: .form)
					.keyboardType(
						fieldType == .email ? .emailAddress : .namePhonePad
					)
					.textContentType(
						fieldType == .email ? .emailAddress :
							fieldType == .firstName ? .givenName : .familyName
					)
					.focused($focusedField, equals: .email)
					.id(Field.email)
					.onTapGesture {}
			}
		case .password:
			VStack {
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
		case .searchBar:
			ZStack(alignment: .leading) {
				if fieldValue.isEmpty {
					Text(hintKey)
						.foregroundColor(colorScheme == .dark ? .gray : .secondary)
						.applyTextStyle(style: .formHeader)
				}
				TextField("", text: $fieldValue, onEditingChanged: { isEditing in
					self.isEditing = isEditing
				})
				.applyTextFieldStyle(style: .searchBar)
				.keyboardType(.alphabet)
				.textCase(nil)
				.textContentType(.organizationName)
				.focused($focusedField, equals: .searchBar)
				.id(Field.searchBar)
				.overlay(
					Group {
						if fieldValue.isEmpty, !isEditing {
							Image(systemName: "magnifyingglass")
								.foregroundColor(.black)
								.imageScale(.large)
						}
						if !fieldValue.isEmpty {
							Button(action: {
								fieldValue = ""
							}) {
								Image(systemName: "multiply.circle.fill")
									.foregroundColor(colorScheme == .dark ? .gray : .secondary)
							}
						}
					}
					.padding(.trailing, 12),
					alignment: .trailing
				)
			}
		case .searchBarItems:
			ZStack(alignment: .leading) {
				TextField(LocalizedStringKey("search_item_label"), text: $fieldValue, onEditingChanged: { isEditing in
					self.isEditing = isEditing
				})
				.applyTextFieldStyle(style: .searchBarItems)
				.keyboardType(.alphabet)
				.textCase(nil)
				.textContentType(.organizationName)
				.focused($focusedField, equals: .searchBar)
				.id(Field.searchBar)
				.overlay(
					Group {
						if fieldValue.isEmpty, !isEditing {
							Image(systemName: "magnifyingglass")
								.foregroundColor(.black)
								.imageScale(.large)
						}
						if !fieldValue.isEmpty {
							Button(action: {
								fieldValue = ""
							}) {
								Image(systemName: "xmark")
									.foregroundColor(colorScheme == .dark ? .gray : .secondary)
							}
						}
					}
					.padding(.trailing, 12),
					alignment: .trailing
				)
			}
		}
	}
}
