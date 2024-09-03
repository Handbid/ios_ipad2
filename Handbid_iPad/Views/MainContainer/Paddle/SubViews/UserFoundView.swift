// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct UserFoundView: View {
	@ObservedObject var viewModel: PaddleViewModel
	private let model: RegistrationModel

	init(viewModel: PaddleViewModel, model: RegistrationModel) {
		self.viewModel = viewModel
		self.model = model
	}

	var body: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "paddle_label_userFound"))
		{
			VStack {
				Text("\(model.firstName ?? "nil") \(model.lastName ?? "nil")")
					.font(TypographyStyle.h2.asFont())
					.fontWeight(.bold)
					.padding(.all, 16)

				Text(model.email ?? "nil")
					.applyTextStyle(style: .body)
					.padding(.bottom, 32)

				Button<Text>.styled(config: .secondaryButtonStyle,
				                    action: {
				                    	viewModel.subView = .confirmInformation(model)
				                    },
				                    label: {
				                    	Text(
				                    		LocalizedStringKey("paddle_btn_itsMe")
				                    	)
				                    }).padding(.all, 8)

				Button<Text>.styled(config: .fifthButtonStyle,
				                    action: {
				                    	viewModel.subView = .findPaddle
				                    },
				                    label: {
				                    	Text(
				                    		LocalizedStringKey("paddle_btn_notMe")
				                    	)
				                    }).padding(.all, 8)
			}
			.padding(32)
		}
	}
}
