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
				Text(LocalizedStringKey("Change Password"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("ChangePassword")
		}
	}
}
