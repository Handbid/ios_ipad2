// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct EnterPinAlertView: View {
	var title: String
	var bodyText: String
	@ObservedObject var viewModel: EnterPinAlertViewModel

	var body: some View {
		VStack(spacing: 16) {
			Text(title)
				.font(.headline)
			Text(bodyText)
			SecureField("PIN", text: $viewModel.pin)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			HStack {
				Button("Cancel") {
					AlertManager.shared.dismissAlert()
				}
				Spacer()
				Button("Confirm") {
					viewModel.confirm()
					AlertManager.shared.dismissAlert()
				}
			}
		}
		.padding()
		.background(Color.white)
		.cornerRadius(12)
		.padding()
	}
}
