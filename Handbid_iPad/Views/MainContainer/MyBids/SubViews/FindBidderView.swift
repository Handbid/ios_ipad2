// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FindBidderView: View {
	@ObservedObject var viewModel: MyBidsViewModel
	@FocusState var focusedField: Field?
	var inspection = Inspection<Self>()

	var body: some View {
		content
	}

	private var content: some View {
		OverlayInternalView(cornerRadius: 40,
		                    backgroundColor: .itemBackground,
		                    topLabel: String(localized: "myBids_label_findBidderByPaddleNumber"))
		{
			VStack {
				FormField(fieldType: .number,
				          labelKey: LocalizedStringKey("paddle_label_paddleNumber"),
				          hintKey: LocalizedStringKey("myBids_label_findBidderByPaddleNumber"),
				          fieldValue: $viewModel.paddleNumber,
				          focusedField: _focusedField)
					.padding(.bottom, 8)

				if !viewModel.error.isEmpty {
					Text(viewModel.error)
						.applyTextStyle(style: .error)
						.frame(maxWidth: .infinity, alignment: .center)
						.accessibilityIdentifier("findBidderErrorField")
						.frame(height: 30)
				}

				Button<Text>.styled(config: .fifthButtonStyle, action: {
					if viewModel.validatePaddleNumber() {
						viewModel.requestFindingBidder()
					}
				}, label: {
					Text(LocalizedStringKey("myBids_btn_searchBidder"))
						.textCase(.uppercase)
				})
			}
			.padding(32)
			.frame(maxWidth: .infinity)
		}
		.padding(32)
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
	}

	private var isInputValid: Bool {
		!viewModel.paddleNumber.isEmpty
	}
}
