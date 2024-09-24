// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct MyBidsView: View {
	enum SubView {
		case findPaddle
	}

	@StateObject var viewModel: MyBidsViewModel

	init(viewModel: MyBidsViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		LoadingOverlay(isLoading: $viewModel.isLoading) {
			MyBidsSubViewFactory(viewModel: viewModel)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.containerBackground)
				.edgesIgnoringSafeArea(.all)
				.accessibilityIdentifier("MyBidsView")
		}
	}
}
