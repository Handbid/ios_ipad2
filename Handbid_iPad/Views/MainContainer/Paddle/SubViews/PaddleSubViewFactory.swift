// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleSubViewFactory: View {
	@ObservedObject var viewModel: PaddleViewModel

	var body: some View {
		switch viewModel.subView {
		case .findPaddle:
			FindPadleView(viewModel: viewModel)
		case .createAccount:
			CreateAccountView(viewModel: viewModel)
		case let .userFound(data):
			UserFoundView(viewModel: viewModel, model: data)
		default:
			EmptyView()
		}
	}
}
