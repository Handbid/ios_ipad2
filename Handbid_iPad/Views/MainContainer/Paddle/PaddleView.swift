// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleView: View {
	enum SubView {
		case findPaddle, createAccount
		case userFound(RegistrationModel)
		case confirmInformation(RegistrationModel)
	}

	@StateObject var viewModel: PaddleViewModel

	init(viewModel: PaddleViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		LoadingOverlay(isLoading: $viewModel.isLoading) {
			PaddleSubViewFactory(viewModel: viewModel)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.containerBackground)
				.edgesIgnoringSafeArea(.all)
				.accessibilityIdentifier("PaddleView")
		}
	}
}
