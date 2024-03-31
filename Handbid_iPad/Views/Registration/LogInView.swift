// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?
	@ObservedObject private var viewModel = LogInViewModel()

	private func getImageView(size: CGSize) -> some View {
		Image("LogoLogin")
			.resizable()
			.scaledToFit()
			.frame(width: size.width * 0.2)
			.accessibilityIdentifier("loginLogo")
	}

	private func getTextFields() -> some View {
		VStack {
			FormField(fieldValue: $viewModel.login,
			          labelKey: LocalizedStringKey("email"),
			          hintKey: LocalizedStringKey("emailHint"))

			PasswordField(fieldValue: $viewModel.password,
			              labelKey: LocalizedStringKey("password"),
			              hintKey: LocalizedStringKey("passwordHint"))
		}
	}

	var body: some View {
		Text("ups")
//		CenteredWrappingContainer(landscapeWidthFraction: 0.4) { size in
//			VStack {
//				getImageView(size: size)
//
//				Text(LocalizedStringKey("login"))
//					.padding(.bottom, 0.05 * size.height)
//					.subTitleTextStyle()
//					.accessibilityIdentifier("loginHeader")
//
//				getTextFields()
//
//				Button(LocalizedStringKey("login")) {
//					viewModel.logIn()
//				}
//				.solidPrimaryButtonStyle()
//				.padding([.top, .bottom], 0.025 * size.height)
//				.accessibilityIdentifier("loginButton")
//
//				Button(LocalizedStringKey("forgotPassword")) {}
//					.noBackgroundAccentButtonStyle()
//			}
//			.padding([.bottom, .top], 0.05 * size.height)
//			.padding([.leading, .trailing], 0.1 * size.width)
//		}.background(Color.accent)
	}
}
