// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleSubViewFactory: View {
	@ObservedObject var viewModel: PaddleViewModel
	@Binding var subView: PaddleView.SubView

	var body: some View {
		switch subView {
		case .findPaddle:
			FindPadleView(viewModel: viewModel, subView: $subView)
		case .createAccount:
			CreateAccountView(viewModel: viewModel, subView: $subView)
		default:
			EmptyView()
		}
	}
}
