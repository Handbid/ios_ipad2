// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ResetPasswordView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel = ResetPasswordViewModel()
	@State private var pin: String = ""
	@FocusState private var isFocused: Bool
	@State private var isLoading: Bool = false

	var body: some View {
		ZStack {
			OverlayInternalView(cornerRadius: 40) {
				VStack {
					getHeaderText()
					getBodyText()
					getPinView()
					getButtons()
				}.padding()
			}
		}.background {
			backgroundImageView(for: .registrationWelcome)
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
	}

	private func getHeaderText() -> some View {
		Text(LocalizedStringKey("Reset Password"))
			.applyTextStyle(style: .headerTitle)
			.accessibilityIdentifier("ResetPassword")
	}

	private func getBodyText() -> some View {
		Text(LocalizedStringKey("We have sent you a confirmation code by email, please enter the code below."))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("ResetPasswordBody")
	}

	private func getPinView() -> some View {
		VStack(spacing: 20) {
			HStack(spacing: 10) {
				ForEach(Array(pin.prefix(4)), id: \.self) { _ in
					Text("*")
						.applyTextStyle(style: .headerTitle)
				}
				if pin.count < 4 {
					ForEach(0 ..< (4 - pin.count), id: \.self) { _ in
						Text("_")
							.applyTextStyle(style: .headerTitle)
					}
				}
			}
			.padding()

			TextField("", text: $pin)
				.keyboardType(.numberPad)
				.foregroundColor(.clear)
				.accentColor(.clear)
				.background(Color.clear)
				.focused($isFocused)
				.frame(width: 0, height: 0)
				.ignoresSafeArea(.keyboard, edges: .bottom)
				.padding()
				.onChange(of: pin) { _, newValue in
					if newValue.count == 4, !newValue.contains("*"), newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
						coordinator.push(RegistrationPage.changePassword as! T)
						isLoading = true
					}
					else {
						isLoading = false
					}
				}

			if isLoading {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .black))
					.scaleEffect(2.0)
					.padding()
			}
		}
		.onTapGesture {
			isFocused = true
		}
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				coordinator.push(RegistrationPage.changePassword as! T)
			}) {
				Text(LocalizedStringKey("Confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Confirm")
		}
	}
}
