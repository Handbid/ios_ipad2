// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChangePasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ChangePasswordViewModel()

	var body: some View {
		ZStack {
			if viewModel.isCorrectPassword { content } else { content }
		}.background {
			backgroundImageView(for: .registrationWelcome)
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
				Spacer()
			}
			.padding()
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("Change Password"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("ChangePassword")
	}

	private func getTextFields() -> some View {
		VStack(spacing: 20) {
			PasswordField(fieldValue: $viewModel.password,
			              labelKey: LocalizedStringKey("password"),
			              hintKey: LocalizedStringKey("passwordHint"))

			PasswordField(fieldValue: $viewModel.confirmPassword,
			              labelKey: LocalizedStringKey("password"),
			              hintKey: LocalizedStringKey("passwordHint"))
		}
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isCorrectPassword {
				Text(viewModel.errorMessage)
					.applyTextStyle(style: .error)
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
				Text(LocalizedStringKey("Change Password"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("ChangePassword")
		}
	}
}
