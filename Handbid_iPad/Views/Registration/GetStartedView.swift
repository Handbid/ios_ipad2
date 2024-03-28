// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

class GetStartedViewModel2: ObservableObject {
	@Published var textField = ""
	@Published var password = ""
}

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?
	@ObservedObject var viewmodel = LogInViewModel()

	@ObservedObject var viewmodel2 = GetStartedViewModel2()
	@ObservedObject var globalStyle = GlobalStyle()

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
//			Button(LocalizedStringKey("login")) {
//				coordinator.push(RegistrationPage.logIn as! T)
//			}
//			.solidAccentButtonStyle()
//			.accessibilityIdentifier("LoginButton")
//
//			Button(LocalizedStringKey("demoVersion")) {}
//				.solidPrimaryButtonStyle()
//				.disabled(true)
//				.accessibilityIdentifier("DemoButton")
//
//			Button(LocalizedStringKey("btnAboutHandbid")) {}
//				.borderAccentButtonStyle()
//				.accessibilityIdentifier("AboutHandbidButton")

			// MARK: -

			Button<Text>.styled(config: .primaryButtonStyle, action: {}) {
				Text("Button")
			}

			Text("Text")
				.applyTextStyle(config: globalStyle.largeTextStyle)
				.multilineTextAlignment(.center)
				.lineLimit(2)

			Text("Text2")
				.applyTextStyle(config: .smallTextStyle)
				.multilineTextAlignment(.center)
				.lineLimit(2)

			TextField("Text", text: $viewmodel2.textField)
				.applyTextFieldStyle(config: globalStyle.texfField)

			SecureField("password", text: $viewmodel.password, onCommit: {})
				.applySecureTextFieldStyle(config: globalStyle.secureTexfField)
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
