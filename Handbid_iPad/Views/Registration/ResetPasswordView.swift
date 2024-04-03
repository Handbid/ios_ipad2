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
		.onAppear {
			isBlurred = false
			viewModel.resetErrorMessage()
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea()
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
				ForEach(Array(viewModel.pin.prefix(4)), id: \.self) { _ in
					Text("*")
						.applyTextStyle(style: .headerTitle)
				}
				if viewModel.pin.count < 4 {
					ForEach(0 ..< (4 - viewModel.pin.count), id: \.self) { _ in
						Text("_")
							.applyTextStyle(style: .headerTitle)
					}
				}
			}
			.padding()

			TextField("", text: $viewModel.pin)
				.keyboardType(.numberPad)
				.foregroundColor(.clear)
				.accentColor(.clear)
				.background(Color.clear)
				.focused($isFocused)
				.frame(width: 0, height: 0)
				.ignoresSafeArea(.keyboard, edges: .bottom)
				.padding()
				.onChange(of: viewModel.pin) { _, newValue in
					if newValue.count == 4 {
						if !newValue.contains("*"), newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
							isBlurred = true
							coordinator.push(RegistrationPage.changePassword as! T)
						}
						else {
							viewModel.validatePin()
							if !viewModel.isPinValid {
								viewModel.resetErrorMessage()
							}
						}
					}
					else if newValue.count > 4 {
						viewModel.resetErrorMessage()
					}
				}
		}
		.onTapGesture {
			isFocused = true
		}
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
				Text(LocalizedStringKey("Confirm"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("Confirm")
		}
	}
}
