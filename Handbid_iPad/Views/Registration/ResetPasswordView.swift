// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ResetPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		ZStack {
			OverlayInternalView(cornerRadius: 40) {
				VStack {
					getHeaderText()
					getBodyText()
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
		Text(LocalizedStringKey("Reset Password"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("ResetPassword")
	}

	private func getBodyText() -> some View {
		Text(LocalizedStringKey("We have sent you a confirmation code by email, please enter the code below."))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("ResetPasswordBody")
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				coordinator.push(RegistrationPage.changePassword as! T)
			}) {
				Text(LocalizedStringKey("Confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Confirm")
		}
	}
}
