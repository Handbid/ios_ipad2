// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogInView<T: PageProtocol>: View {
    private enum Field: Int, CaseIterable {
        case email, password
    }
    
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@StateObject  private var viewModel = LogInViewModel()
	@State private var isBlurred = false

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
		}
        .keyboardResponsive()
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
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
				Text(LocalizedStringKey("login"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("LogIn")

			Button<Text>.styled(config: .fourthButtonStyle, action: {
				isBlurred = true
				coordinator.push(RegistrationPage.forgotPassword as! T)
			}) {
				Text(LocalizedStringKey("forgotPassword"))
			}.accessibilityIdentifier("ForgotPassword")
		}
	}
}
