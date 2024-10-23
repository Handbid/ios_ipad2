// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct EnterPinAlertView: View {
	var title: String
	var bodyText: String
	@ObservedObject var viewModel: EnterPinAlertViewModel
	@State var showError: Bool = false

	var body: some View {
		VStack(spacing: 16) {
			Text(title)
				.font(.headline)
			Text(bodyText)

			Text("Error")
				.opacity(showError ? 1 : 0)

			SecureField("PIN", text: $viewModel.pin)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			HStack {
				Button("Cancel") {
					AlertManager.shared.dismissAlert()
				}
				Spacer()
				Button("Confirm") {
					viewModel.confirm()
				}
			}
		}
		.padding()
		.background(Color.white)
		.cornerRadius(12)
		.padding()
		.onReceive(viewModel.delegate?.isSuccess ?? Just(nil).eraseToAnyPublisher()) { isSuccess in
			showError = isSuccess == false

			if isSuccess == true {
				AlertManager.shared.dismissAlert()
			}
		}
	}
}
