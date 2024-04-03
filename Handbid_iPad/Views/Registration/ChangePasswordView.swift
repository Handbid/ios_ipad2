// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChangePasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ChangePasswordViewModel()
	@State private var isBlurred = false

	var body: some View {
		ZStack {
			content
		}
		.keyboardResponsive()
		.onAppear {
			isBlurred = false
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
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
			PasswordField(fieldValue: $viewModel.password,
			              labelKey: LocalizedStringKey("registration_label_password"),
			              hintKey: LocalizedStringKey("registration_hint_enterPassword"))

			PasswordField(fieldValue: $viewModel.confirmPassword,
			              labelKey: LocalizedStringKey("registration_label_password"),
			              hintKey: LocalizedStringKey("registration_hint_enterPassword"))
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
