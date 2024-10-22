// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: LogInViewModel
	@State private var isBlurred = false
	@State private var isLoading = false
	@FocusState var focusedField: Field?
	let inspection = Inspection<Self>()

	init(viewModel: LogInViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		LoadingOverlay(isLoading: $isLoading) {
			ZStack {
				content
					.keyboardResponsive()
			}
			.background {
				backgroundView(for: .color(.accentViolet))
			}.alert(LocalizedStringKey("global_label_error"),
			        isPresented: $viewModel.showError)
			{
				Button(LocalizedStringKey("global_btn_ok")) {
					viewModel.resetErrorMessage()
				}
			}
			message: {
				Text(viewModel.errorMessage)
			}.onAppear {
				isBlurred = false
				viewModel.resetErrorMessage()
			}
			.onTapGesture {
				hideKeyboard()
			}
			.onReceive(viewModel.$showError) { _ in
				isBlurred = false
				isLoading = false
			}
			.onReceive(inspection.notice) {
				inspection.visit(self, $0)
			}
			.backButtonNavigation(style: .registration)
			.ignoresSafeArea(.keyboard, edges: .bottom)
		}
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
		Text(LocalizedStringKey("registration_label_login"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_login")
	}

	private func getTextFields() -> some View {
		VStack(spacing: 10) {
			FormField(fieldType: .email,
			          labelKey: LocalizedStringKey("global_label_email"),
			          hintKey: LocalizedStringKey("global_hint_email"),
			          fieldValue: $viewModel.email,
			          focusedField: _focusedField)

			FormField(fieldType: .password,
			          labelKey: LocalizedStringKey("registration_label_password"),
			          hintKey: LocalizedStringKey("registration_hint_enterPassword"),
			          fieldValue: $viewModel.password,
			          focusedField: _focusedField)
		}
	}

	private func getErrorMessage() -> some View {
		VStack(spacing: 10) {
			if !viewModel.isFormValid {
				GeometryReader { geometry in
					Text(viewModel.errorMessage)
						.applyTextStyle(style: .error)
						.frame(minHeight: geometry.size.height)
						.accessibilityIdentifier("registration_label_loginError")
				}
			}
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.logIn()
				isBlurred = true
				isLoading = true
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
