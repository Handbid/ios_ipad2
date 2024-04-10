// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChangePasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ChangePasswordViewModel()
	@State private var isBlurred = false
	@FocusState private var focusedField: Field?

	var body: some View {
		ZStack {
			content
		}
		.onAppear {
			isBlurred = false
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}
		.onTapGesture {
			if focusedField != nil {
				focusedField = nil
				hideKeyboard()
			}
		}
		.keyboardResponsive()
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				getHeaderText()
				getTextFields()
				getErrorMessage()
				getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("registration_label_changePassword"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_changePassword")
	}

	private func getTextFields() -> some View {
		VStack(spacing: 20) {
			FormField(fieldType: .email,
			          labelKey: LocalizedStringKey("registration_label_password"),
			          hintKey: LocalizedStringKey("registration_hint_enterPassword"),
			          fieldValue: $viewModel.password,
			          focusedField: _focusedField)

			FormField(fieldType: .email,
			          labelKey: LocalizedStringKey("registration_label_password"),
			          hintKey: LocalizedStringKey("registration_hint_enterPassword"),
			          fieldValue: $viewModel.confirmPassword,
			          focusedField: _focusedField)
		}
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isCorrectPassword {
				GeometryReader { geometry in
					Text(viewModel.errorMessage)
						.applyTextStyle(style: .error)
						.frame(minHeight: geometry.size.height)
				}
			}
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.validatePassword()
				if viewModel.isCorrectPassword {
					// coordinator.push(RegistrationPage.resetPassword as! T)
				}
			}) {
				Text(LocalizedStringKey("registration_btn_changePassword"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_changePassword")
		}
	}
}
