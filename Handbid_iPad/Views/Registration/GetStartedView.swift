// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = GetStartedViewModel(repository: RegisterRepositoryImpl(NetworkingClient()))
	@State private var contentLoaded = false
	@State private var isBlurred = false

	var body: some View {
		ZStack {
			if contentLoaded { content } else { content }
		}
		.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
				contentLoaded = true
			}
			isBlurred = false
		}
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack {
				getLogoImage()
				getHeaderText()
				getButtons()

			}.padding()
		}
		.blur(radius: isBlurred ? 10 : 0)
		.padding()
	}

	private func getLogoImage() -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(height: 50)
			.onLongPressGesture(minimumDuration: 0.5) {
				isBlurred = true
				coordinator.push(RegistrationPage.chooseEnvironment as! T)
			}
			.accessibilityIdentifier("AppLogo")
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("registration_label_welcomeHandbid"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("registration_label_welcomeHandbid")
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .primaryButtonStyle, action: {
				isBlurred = true
				coordinator.push(RegistrationPage.logIn as! T)
			}) {
				Text(LocalizedStringKey("registration_btn_login"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_login")

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				viewModel.logInAnonymously()
			}) {
				Text(LocalizedStringKey("registration_btn_demoVersion"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_demoVersion")

			Button<Text>.styled(config: .thirdButtonStyle, action: {
				viewModel.openHandbidWebsite()
			}) {
				Text(LocalizedStringKey("registration_btn_aboutHandbid"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("registration_btn_aboutHandbid")
		}
	}
}
