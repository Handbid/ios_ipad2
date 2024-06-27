// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleView: View {
	@ObservedObject var viewModel: PaddleViewModel
	@State var pickedMethod: SearchBy
	@State var email: String

	init(viewModel: PaddleViewModel) {
		self.viewModel = viewModel
		self.pickedMethod = .email
		self.email = ""
	}

	var body: some View {
		VStack(alignment: .center) {
			Spacer()

			Text(LocalizedStringKey("paddle_label_findPaddleByPhoneOrEmail"))
				.applyTextStyle(style: .subheader)
				.lineSpacing(1)
				.multilineTextAlignment(.center)
				.frame(maxWidth: .infinity, alignment: .center)
				.accessibility(label: Text("Paddle Title"))
				.accessibility(identifier: "paddleTitle")

			OverlayInternalView(cornerRadius: 40, backgroundColor: .itemBackground) {
				VStack {
					PickerView(data: SearchBy.allCases) { item in
						Text(item.getLocalizedLabel())
							.applyTextStyle(style: .leadingLabel)
					}
					.padding(.bottom, 32)

					TextField(LocalizedStringKey("global_hint_email"), text: $email)
						.applyTextFieldStyle(style: .form)
						.keyboardType(.emailAddress)
						.textContentType(.emailAddress)
						.padding(.bottom, 16)

					Button<Text>.styled(config: .secondaryButtonStyle, action: {}, label: {
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
