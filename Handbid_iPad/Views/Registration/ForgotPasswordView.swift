// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ForgotPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ForgotPasswordViewModel()
	@State private var isBlurred = false
    @FocusState private var isFocused: Bool

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
        .onTapGesture {
            if isFocused {
                isFocused = false
            }
        }
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				getHeaderText()
					.animation(.easeInOut(duration: 0.3), value: !viewModel.isFormValid)
				getTextFields()
					.animation(.easeInOut(duration: 0.3), value: !viewModel.isFormValid)
				getErrorMessage()
					.animation(.easeInOut(duration: 0.3), value: !viewModel.isFormValid)
				getButtons()
				Spacer()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("Forgot Password"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("GetStartedView")
	}

	private func getTextFields() -> some View {
		VStack {
			FormField(fieldValue: $viewModel.email,
			          labelKey: LocalizedStringKey("email"),
			          hintKey: LocalizedStringKey("emailHint"))
            .focused($isFocused, equals: true)
		}.padding(.bottom)
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isFormValid {
				Text(viewModel.errorMessage)
					.applyTextStyle(style: .error)
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
				Text(LocalizedStringKey("Confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Confirm")
		}
	}
}
