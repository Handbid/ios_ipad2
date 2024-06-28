// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleView: View {
	@ObservedObject var viewModel: PaddleViewModel
	@State var pickedMethod: SearchBy
	@State var email: String
	@State var phone: String
	@State var countryCode: String
	@State var error: String

	init(viewModel: PaddleViewModel) {
		self.viewModel = viewModel
		self.pickedMethod = .email
		self.email = ""
		self.phone = ""
		self.countryCode = "+1"
		self.error = ""
	}

	var body: some View {
		VStack(alignment: .center) {
			OverlayInternalView(cornerRadius: 40,
			                    backgroundColor: .itemBackground,
			                    topLabel: String(localized: "paddle_label_findPaddleByPhoneOrEmail"))
			{
				VStack {
					let picker = PickerView(data: SearchBy.allCases, selection: $pickedMethod) { item in
						Text(item.getLocalizedLabel())
					}

					if !error.isEmpty {
						picker

						Text(error)
							.applyTextStyle(style: .error)
							.frame(maxWidth: .infinity, alignment: .center)
							.background {
								RoundedRectangle(cornerRadius: 25.0)
									.fill(.errorBackground)
							}
					}
					else {
						picker.padding(.bottom, 48)
					}

					switch pickedMethod {
					case .email:
						TextField(LocalizedStringKey("global_hint_email"), text: $email)
							.applyTextFieldStyle(style: .form)
							.keyboardType(.emailAddress)
							.textContentType(.emailAddress)
							.padding(.bottom, 16)
					case .cellPhone:
						HStack {
							Picker("Coutnry code", selection: $countryCode) {
								Text("+1").tag("+1")
								Text("+273").tag("+273")
								Text("+32").tag("+32")
							}
							.pickerStyle(.menu)
							.frame(height: 54)
							.background {
								RoundedRectangle(cornerRadius: 8)
									.stroke(.hbGray, lineWidth: 1)
							}

							TextField(LocalizedStringKey("paddle_hint_cellPhone"), text: $phone)
								.applyTextFieldStyle(style: .form)
								.keyboardType(.phonePad)
								.textContentType(.telephoneNumber)
						}
						.padding(.bottom, 16)
					}

					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						error = "Test error"
					}, label: {
						Text(LocalizedStringKey("global_btn_continue"))
							.textCase(.uppercase)
					})
					.padding(.bottom, 16)

					Button<Text>.styled(config: .fifthButtonStyle, action: {}, label: {
						Text(LocalizedStringKey("paddle_btn_createNewAccount"))
							.textCase(.uppercase)
					})
					.padding(.bottom, 16)
				}
				.padding()
				.frame(maxWidth: .infinity)
			}
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.containerBackground)
		.edgesIgnoringSafeArea(.all)
		.accessibilityIdentifier("PaddleView")
	}
}
