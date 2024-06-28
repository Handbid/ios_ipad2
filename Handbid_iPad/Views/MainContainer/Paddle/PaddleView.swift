// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleView: View {
	enum SubView {
		case findPaddle, createAccount, userFound, confirmInformation
	}

	@StateObject var viewModel: PaddleViewModel
	@State var subView: SubView
	init(viewModel: PaddleViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self.subView = .findPaddle
	}

	var body: some View {
		PaddleSubViewFactory(viewModel: viewModel, subView: $subView)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(.containerBackground)
			.edgesIgnoringSafeArea(.all)
			.accessibilityIdentifier("PaddleView")
	}
}
