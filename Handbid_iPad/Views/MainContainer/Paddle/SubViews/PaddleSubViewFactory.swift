// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleSubViewFactory: View {
	@ObservedObject var viewModel: PaddleViewModel
	let inspection = Inspection<Self>()

	var body: some View {
		let view: any View = switch viewModel.subView {
		case .findPaddle:
			FindPadleView(viewModel: viewModel)
		case .createAccount:
			CreateAccountView(viewModel: viewModel)
		case let .userFound(data):
			UserFoundView(viewModel: viewModel, model: data)
		case let .confirmInformation(data):
			ConfirmUserInformationView(viewModel: viewModel, model: data)
		}

		AnyView(view)
			.onReceive(inspection.notice) {
				inspection.visit(self, $0)
			}
	}
}
