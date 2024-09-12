// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ConfirmUserInformationView: View {
	@ObservedObject var viewModel: PaddleViewModel
	private let model: RegistrationModel

	init(viewModel: PaddleViewModel, model: RegistrationModel) {
		self.viewModel = viewModel
		self.model = model
	}

	var body: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "paddle_label_confirmInformation"))
		{
			VStack {
				HStack {
					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_firstName"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.firstName ?? "N/A")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("firstNameField")

						Text(LocalizedStringKey("global_label_email"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.email ?? "N/A")
							.font(TypographyStyle.small.asFont())
							.padding()
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("emailField")
					}

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_lastName"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.lastName ?? "N/A")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("lastNameField")

						Text(LocalizedStringKey("global_label_cellPhone"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.phoneNumber ?? "N/A")
							.font(TypographyStyle.small.asFont())
							.padding()
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("cellPhoneField")
					}
				}

				Divider()

				HStack(alignment: .bottom) {
					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_paddleNumber"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.currentPaddleNumber?.formatted() ?? "N/A")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.foregroundStyle(.accent)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("paddleNumberField")
					}

					Divider()

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_tableNumber"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(model.currentPlacement ?? "N/A")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("tableNumberField")
					}

					Divider()

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_sponsor"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						let sponsor = model.sponsorName ?? ""

						Text(sponsor.isEmpty ? "N/A" : sponsor)
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
							.accessibilityIdentifier("sponsorField")
					}
				}

				Button<Text>.styled(config: .secondaryButtonStyle,
				                    action: {
				                    	viewModel.confirmFoundUser(model: model)
				                    },
				                    label: {
				                    	Text(LocalizedStringKey("paddle_btn_confirm"))
				                    		.textCase(.uppercase)
				                    })
				                    .accessibilityIdentifier("confirmButton")
			}.padding(32)
		}
	}
}
