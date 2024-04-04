// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ResetPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ResetPasswordViewModel()
	@FocusState private var isFocused: Bool
	@State private var isBlurred = false

	var body: some View {
		ZStack {
			content
		}
		.background {
			backgroundView(for: .color(.accentViolet))
		}
		.keyboardResponsive()
		.onAppear {
			isBlurred = false
			viewModel.resetErrorMessage()
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				getHeaderText()
				getBodyText()
				getPinView()
				getErrorMessage()
				getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("registration_label_resetPassword"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_resetPassword")
	}

	private func getBodyText() -> some View {
		Text(LocalizedStringKey("registration_label_confirmationCodeByEmail"))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("registration_label_confirmationCodeByEmail")
	}

	private func getPinView() -> some View {
		PinView(pin: $viewModel.pin, onPinComplete: { _ in
			isBlurred = true
			coordinator.push(RegistrationPage.changePassword as! T)
		}, onPinInvalid: {
			viewModel.validatePin()
		}, maxLength: 4)
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isPinValid {
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
				if viewModel.isPinValid, viewModel.pin.count == 4 {
					isBlurred = true
					coordinator.push(RegistrationPage.changePassword as! T)
				}
			}) {
				Text(LocalizedStringKey("registration_btn_confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_confirm")
		}
	}
}
