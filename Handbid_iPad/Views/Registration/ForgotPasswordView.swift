// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ForgotPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ForgotPasswordViewModel()
	@State private var isBlurred = false

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
			FormField(fieldValue: $viewModel.email,
			          labelKey: LocalizedStringKey("registration_label_email"),
			          hintKey: LocalizedStringKey("registration_hint_email"))
		}.padding(.bottom)
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isFormValid {
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
				viewModel.valideEmail()
				if viewModel.isFormValid {
					isBlurred = true
					coordinator.push(RegistrationPage.resetPassword as! T)
				}
			}) {
				Text(LocalizedStringKey("registration_btn_confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_confirm")
		}
	}
}
