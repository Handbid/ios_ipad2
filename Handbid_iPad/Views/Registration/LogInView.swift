// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct LogInView<T: PageProtocol>: View {
	private enum Field: Int, CaseIterable {
		case email, password
	}

	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject private var viewModel = LogInViewModel(repository: RegisterRepositoryImpl(NetworkingClient()), authManager: AuthManager())
	@State private var isBlurred = false
	@State private var keyboardHeight: CGFloat = 0

	var body: some View {
		ZStack {
			content
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}.alert(isPresented: $viewModel.showError) {
			Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
		}
		.onAppear {
			isBlurred = false
			viewModel.resetErrorMessage()
			NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
				if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
					keyboardHeight = keyboardSize.height
				}
			}
			NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
				keyboardHeight = 0
			}
		}
		.keyboardResponsive()
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				getLogoImage()
				getHeaderText()
				getTextFields()
				getErrorMessage()
				getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
		.padding(.bottom, keyboardHeight)
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 40)
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("registration_label_login"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_login")
	}

	private func getTextFields() -> some View {
		VStack(spacing: 20) {
			FormField(fieldValue: $viewModel.email,
			          labelKey: LocalizedStringKey("registration_label_email"),
			          hintKey: LocalizedStringKey("registration_hint_email"))

			PasswordField(fieldValue: $viewModel.password,
			              labelKey: LocalizedStringKey("registration_label_password"),
			              hintKey: LocalizedStringKey("registration_hint_enterPassword"))
		}
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
				viewModel.logIn()
			}) {
				Text(LocalizedStringKey("registration_btn_login"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_login")

			Button<Text>.styled(config: .fourthButtonStyle, action: {
				isBlurred = true
				coordinator.push(RegistrationPage.forgotPassword as! T)
			}) {
				Text(LocalizedStringKey("registration_btn_password"))
			}.accessibilityIdentifier("registration_btn_password")
		}
	}
}
