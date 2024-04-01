// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = GetStartedViewModel()
	@State private var contentLoaded = false

	var body: some View {
		ZStack {
			if contentLoaded {
				OverlayInternalView(cornerRadius: 40) {
					VStack {
						getLogoImage()
						getHeaderText()
						getButtons()
					}.padding()
				}
			}
		}.onAppear {
			contentLoaded = true
		}
		.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.ignoresSafeArea()
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 50)
			.onLongPressGesture(minimumDuration: 0.5) {
				coordinator.push(RegistrationPage.chooseEnvironment as! T)
			}
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("welcomeToHandbid"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("GetStartedView")
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .primaryButtonStyle, action: {
				coordinator.push(RegistrationPage.logIn as! T)
			}) {
				Text(LocalizedStringKey("login"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("LoginButton")

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.logInAnonymously()
			}) {
				Text(LocalizedStringKey("demoVersion"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("DemoButton")

			Button<Text>.styled(config: .thirdButtonStyle, action: {
				viewModel.openHandbidWebsite()
			}) {
				Text(LocalizedStringKey("btnAboutHandbid"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("AboutHandbidButton")
		}
	}
}
