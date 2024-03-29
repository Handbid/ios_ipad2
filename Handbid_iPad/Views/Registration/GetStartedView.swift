// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?
	@ObservedObject var viewmodel = LogInViewModel()

	private func getLogoImage(_ size: CGSize) -> some View {
		Image("LogoSplash")
			.resizable()
			.scaledToFit()
			.frame(width: size.width * 0.3)
			.onLongPressGesture(minimumDuration: 0.5) {
				if EnvironmentManager.isProdActive() {
					EnvironmentManager.setEnvironment(for: .d1)
					viewmodel.fetchAppVersion()
				}
				else {
					EnvironmentManager.setEnvironment(for: .prod)
					viewmodel.fetchAppVersion()
				}
			}
			.accessibilityIdentifier("AppLogo")
	}

	private func getButtons() -> some View {
		VStack {
			Button(LocalizedStringKey("login")) {
				coordinator.push(RegistrationPage.logIn as! T)
			}
			.solidAccentButtonStyle()
			.accessibilityIdentifier("LoginButton")

			Button(LocalizedStringKey("demoVersion")) {}
				.solidPrimaryButtonStyle()
				.disabled(true)
				.accessibilityIdentifier("DemoButton")

			Button(LocalizedStringKey("btnAboutHandbid")) {}
				.borderAccentButtonStyle()
				.accessibilityIdentifier("AboutHandbidButton")
		}
	}

	var body: some View {
		CenteredWrappingContainer(landscapeWidthFraction: 0.4) { size in
			VStack {
				getLogoImage(size)

				Text(LocalizedStringKey("welcomeToHandbid"))
					.wrapTextModifier()
					.titleTextStyle()
					.padding([.bottom, .top], 0.05 * size.height)
					.accessibilityIdentifier("GetStartedView")

				getButtons()
			}
			.padding([.bottom, .top], 0.05 * size.height)
			.padding([.leading, .trailing], 0.1 * size.width)
		}.background {
			Image("SplashBackground")
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()
		}
	}
}
