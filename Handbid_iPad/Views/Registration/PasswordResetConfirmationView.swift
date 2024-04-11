// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

struct PasswordResetConfirmationView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
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
		}
		.backButtonNavigation(style: .registration)
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				getHeaderText()
				getBodyText()
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
		Text(LocalizedStringKey("registration_label_resetLinkByEmail"))
			.applyTextStyle(style: .body)
			.accessibilityIdentifier("registration_label_resetLinkByEmail")
	}

	private func getButtons() -> some View {
		VStack(spacing: 10) {
			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				coordinator.popToRoot()
			}) {
				Text(LocalizedStringKey("global_btn_ok"))
					.textCase(.uppercase)
			}.accessibilityIdentifier("global_btn_ok")
		}
	}
}
