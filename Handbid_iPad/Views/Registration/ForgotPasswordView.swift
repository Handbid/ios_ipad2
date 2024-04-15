// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct ForgotPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ForgotPasswordViewModel(repository: ResetPasswordRepositoryImpl(NetworkingClient()))
	@State private var isBlurred = false
	@FocusState private var focusedField: Field?

	var body: some View {
		ZStack {
			content
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}
		.onAppear {
			isBlurred = false
			viewModel.resetErrorMessage()
		}
		.onReceive(viewModel.$isSuccessfulRequest) { value in
			isBlurred = false
			if value {
				coordinator.push(RegistrationPage.resetPasswordConfirmation as! T)
			}
		}
		.onTapGesture {
			hideKeyboard()
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
		Text(LocalizedStringKey("registration_label_forgotPassword"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_forgotPassword")
	}

	private func getTextFields() -> some View {
		VStack {
			FormField(fieldType: .email,
			          labelKey: LocalizedStringKey("registration_label_email"),
			          hintKey: LocalizedStringKey("registration_hint_email"),
			          fieldValue: $viewModel.email,
			          focusedField: _focusedField)
		}.padding(.bottom)
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isFormValid || !viewModel.isSuccessfulRequest {
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
				viewModel.validateEmail()
				if viewModel.isFormValid {
					viewModel.requestPasswordReset()
					isBlurred = true
				}
			}) {
				Text(LocalizedStringKey("registration_btn_confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_confirm")
		}
	}
}
