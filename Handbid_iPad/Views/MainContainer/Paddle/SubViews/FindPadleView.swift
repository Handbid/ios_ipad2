// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FindPadleView: View {
	@ObservedObject var viewModel: PaddleViewModel
	var inspection = Inspection<Self>()

	var body: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "paddle_label_findPaddleByPhoneOrEmail"))
		{
			VStack {
				let picker = PickerView(data: SearchBy.allCases,
				                        selection: $viewModel.pickedMethod)
				{ item in
					Text(item.getLocalizedLabel())
				}
				.accessibilityIdentifier("findPaddleMethodPicker")

				if !viewModel.error.isEmpty {
					picker

					Text(viewModel.error)
						.applyTextStyle(style: .error)
						.frame(maxWidth: .infinity, alignment: .center)
						.background {
							RoundedRectangle(cornerRadius: 25.0)
								.fill(.errorBackground)
						}
						.accessibilityIdentifier("findPaddleErrorField")
				}
				else {
					picker.padding(.bottom, 48)
				}

				switch viewModel.pickedMethod {
				case .email:
					TextField(LocalizedStringKey("global_hint_email"),
					          text: $viewModel.email)
						.applyTextFieldStyle(style: .form)
						.keyboardType(.emailAddress)
						.textContentType(.emailAddress)
						.padding(.bottom, 16)
						.accessibilityIdentifier("findPaddleEmailForm")
				case .cellPhone:
					PhoneField(hintKey: "paddle_hint_cellPhone",
					           countries: viewModel.countries,
					           selectedCountryCode: $viewModel.countryCode,
					           fieldValue: $viewModel.phone)
						.padding(.bottom, 16)
						.accessibilityIdentifier("findPaddlePhoneForm")
				}

				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					viewModel.requestFindingPaddle()
				}, label: {
					Text(LocalizedStringKey("global_btn_continue"))
						.textCase(.uppercase)
				})
				.padding(.bottom, 16)
				.accessibilityIdentifier("findPaddleContinueButton")

				Button<Text>.styled(config: .fifthButtonStyle, action: {
					viewModel.subView = .createAccount
				}, label: {
					Text(LocalizedStringKey("paddle_btn_createNewAccount"))
						.textCase(.uppercase)
				})
				.padding(.bottom, 16)
				.accessibilityIdentifier("findPaddleCreateNewAccountButton")
			}
			.padding(32)
			.frame(maxWidth: .infinity)
		}
		.padding(32)
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
	}
}