// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var contentLoaded = false

	var body: some View {
		ZStack {
			if contentLoaded {
				CenteredWrappingContainer(landscapeWidthFraction: 0.4) { size in
					VStack {
						getLogoImage(size)
						getHeaderText()
						getButtons()
					}
					.padding([.bottom, .top], 0.05 * size.height)
					.padding([.leading, .trailing], 0.1 * size.width)
				}
			}
		}.onAppear {
			contentLoaded = true
		}
		.background {
			backgroundImageView(for: .registrationWelcome)
		}
	}

	private func getLogoImage(_ size: CGSize) -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(width: size.width * 0.3)
			.onLongPressGesture(minimumDuration: 5) {
				coordinator.push(RegistrationPage.chooseEnvironment as! T)
			}
			.accessibilityIdentifier("AppLogo")
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .primaryButtonStyle, action: {
				coordinator.push(RegistrationPage.logIn as! T)
			}) {
				Text(LocalizedStringKey("login"))
			}.accessibilityIdentifier("LoginButton")

			Button<Text>.styled(config: .secondaryButtonStyle, action: {}) {
				Text(LocalizedStringKey("demoVersion"))
			}.accessibilityIdentifier("DemoButton")

			Button<Text>.styled(config: .thirdButtonStyle, action: {}) {
				Text(LocalizedStringKey("btnAboutHandbid"))
			}.accessibilityIdentifier("AboutHandbidButton")
		}
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("welcomeToHandbid"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("GetStartedView")
	}
}
