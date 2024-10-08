// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CreateAccountView: View {
	@ObservedObject var viewModel: PaddleViewModel

	var body: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "paddle_label_createBidderAccount"))
		{
			VStack {
				let nameFields = HStack {
					FormField(fieldType: .firstName,
					          labelKey: LocalizedStringKey("paddle_label_firstName"),
					          hintKey: LocalizedStringKey("paddle_hint_firstName"),
					          fieldValue: $viewModel.firstName)
						.accessibilityIdentifier("createAccountFirstNameField")

					FormField(fieldType: .lastName,
					          labelKey: LocalizedStringKey("paddle_label_lastName"),
					          hintKey: LocalizedStringKey("paddle_hint_lastName"),
					          fieldValue: $viewModel.lastName)
						.accessibilityIdentifier("createAccountLastNameField")
				}
				.padding(.bottom, 16)

				if !viewModel.error.isEmpty {
					Text(viewModel.error)
						.applyTextStyle(style: .error)
						.frame(maxWidth: .infinity, alignment: .center)
						.background {
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.errorBackground)
						}
						.accessibilityIdentifier("createAccountErrorField")

					nameFields
				}
				else {
					nameFields.padding(.top, 48)
				}

				FormField(fieldType: .email,
				          labelKey: "global_label_email",
				          hintKey: "global_hint_email",
				          fieldValue: $viewModel.email)
					.padding(.bottom, 16)
					.accessibilityIdentifier("createAccountEmailField")

				PhoneField(labelKey: "global_label_cellPhone",
				           hintKey: "paddle_hint_cellPhone",
				           countries: viewModel.countries,
				           selectedCountryCode: $viewModel.countryCode,
				           fieldValue: $viewModel.phone)
					.padding(.bottom, 16)
					.accessibilityIdentifier("createAccountPhoneField")

				Button<Text>.styled(config: .primaryButtonStyle,
				                    action: {
				                    	viewModel.registerNewUser()
				                    },
				                    label: {
				                    	Text(LocalizedStringKey("paddle_btn_createAccount"))
				                    		.textCase(.uppercase)
				                    })
				                    .padding(.bottom, 16)
				                    .accessibilityIdentifier("createAccountButton")

				Button<Text>.styled(config: .thirdButtonStyle,
				                    action: {
				                    	viewModel.error = ""
				                    	viewModel.subView = .findPaddle
				                    },
				                    label: {
				                    	Text(LocalizedStringKey("global_btn_back"))
				                    		.textCase(.uppercase)
				                    })
				                    .accessibilityIdentifier("createAccountBackButton")
			}
			.padding(32)
		}
		.padding(32)
        .keyboardResponsive()
	}
}
