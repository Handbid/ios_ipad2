// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct UserFoundView: View {
	@ObservedObject var viewModel: PaddleViewModel
	@Binding var subView: PaddleView.SubView
	var body: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "paddle_label_userFound"))
		{
			VStack {
				Text(viewModel.user?.name ?? "nil")
					.font(TypographyStyle.h2.asFont())
					.fontWeight(.bold)
					.padding(.all, 16)

				Text(viewModel.user?.email ?? "nil")
					.applyTextStyle(style: .body)
					.padding(.bottom, 32)

				Button<Text>.styled(config: .secondaryButtonStyle,
				                    action: {},
				                    label: {
				                    	Text(
				                    		LocalizedStringKey("paddle_btn_itsMe")
				                    	)
				                    }).padding(.all, 8)

				Button<Text>.styled(config: .fifthButtonStyle,
				                    action: {},
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
