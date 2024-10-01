// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AddCardAlertView: View {
	var title: String
	@ObservedObject var viewModel: AddCardAlertViewModel

	var body: some View {
		VStack(spacing: 16) {
			Text(title)
				.font(.headline)

			TextField("Card Number", text: $viewModel.cardNumber)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			TextField("Expiry Date", text: $viewModel.expiryDate)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			HStack {
				Button("Close") {
					AlertManager.shared.dismissAlert()
				}
				Spacer()
				Button("Save") {
					viewModel.save()
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
