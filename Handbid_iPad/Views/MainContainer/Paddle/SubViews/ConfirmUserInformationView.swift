// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ConfirmUserInformationView: View {
	@ObservedObject var viewModel: PaddleViewModel
	@Binding var subView: PaddleView.SubView

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

						Text(viewModel.user?.firstName ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)

						Text(LocalizedStringKey("global_label_email"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.email ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.frame(maxWidth: .infinity,
							       alignment: .leading)
					}

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_lastName"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.lastName ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)

						Text(LocalizedStringKey("global_label_cellPhone"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.userPhone ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.frame(maxWidth: .infinity,
							       alignment: .leading)
					}
				}

				Divider()

				HStack {
					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_paddleNumber"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.currentPaddleNumber ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.foregroundStyle(.accent)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
					}

					Divider()

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_tableNumber"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.currentPaddleNumber ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
					}

					Divider()

					VStack(alignment: .leading) {
						Text(LocalizedStringKey("paddle_label_sponsor"))
							.applyTextStyle(style: .leadingLabel)
							.textCase(.uppercase)

						Text(viewModel.user?.currentPaddleNumber ?? "nil")
							.font(TypographyStyle.h2.asFont())
							.fontWeight(.bold)
							.padding()
							.padding(.bottom, 16)
							.frame(maxWidth: .infinity,
							       alignment: .leading)
					}
				}

				Button<Text>.styled(config: .secondaryButtonStyle,
				                    action: {},
				                    label: {
				                    	Text(LocalizedStringKey("paddle_btn_confirm"))
				                    		.textCase(.uppercase)
				                    })
			}.padding(32)
		}
	}
}
