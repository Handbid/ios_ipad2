// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = LogInViewModel()
	@State private var showError = false // State variable to track error display

	var body: some View {
		ZStack {
			if showError { // Render OverlayInternalView with corner radius when error is shown
				OverlayInternalView(cornerRadius: 40) {
					content
				}
			}
			else { // Render OverlayInternalView without corner radius when no error
				OverlayInternalView(cornerRadius: 40) {
					content
				}
			}
		}
		.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.onAppear {
			viewModel.resetErrorMessage()
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
	}

	private var content: some View {
		ScrollView {
			VStack {
				getLogoImage()
				getHeaderText()
				getTextFields()
				getErrorMessage()
				getButtons()
				Spacer()
			}.padding()
		}
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 40)
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("login"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("GetStartedView")
	}

	private func getTextFields() -> some View {
		VStack(spacing: 20) {
			FormField(fieldValue: $viewModel.email,
			          labelKey: LocalizedStringKey("email"),
			          hintKey: LocalizedStringKey("emailHint"))

			PasswordField(fieldValue: $viewModel.password,
			              labelKey: LocalizedStringKey("password"),
			              hintKey: LocalizedStringKey("passwordHint"))
		}
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isFormValid {
				Text(viewModel.errorMessage)
					.applyTextStyle(style: .error)
			}
		}
		.onChange(of: viewModel.isFormValid) { _, newValue in
			showError = !newValue
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.logIn(email: viewModel.email, password: viewModel.password)
				// coordinator.push(RegistrationPage.logIn as! T)
			}) {
				Text(LocalizedStringKey("login"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("LogIn")

			Button<Text>.styled(config: .fourthButtonStyle, action: {
				coordinator.push(RegistrationPage.forgotPassword as! T)
			}) {
				Text(LocalizedStringKey("forgotPassword"))
			}.accessibilityIdentifier("ForgotPassword")
		}
	}
}
