// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChangePasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		ZStack {
			OverlayInternalView(cornerRadius: 40) {
				VStack {
					getHeaderText()
					getTextFields()
					getButtons()
				}.padding()
			}
		}.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("Change Password"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("ChangePassword")
	}

	private func getTextFields() -> some View {
		VStack {
			//            FormField(fieldValue: $viewModel.login,
			//                      labelKey: LocalizedStringKey("email"),
			//                      hintKey: LocalizedStringKey("emailHint"))
//
			//            PasswordField(fieldValue: $viewModel.password,
			//                          labelKey: LocalizedStringKey("password"),
			//                          hintKey: LocalizedStringKey("passwordHint"))
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				// coordinator.push(RegistrationPage.resetPassword as! T)
			}) {
				Text(LocalizedStringKey("Change Password"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("ChangePassword")
		}
	}
}
