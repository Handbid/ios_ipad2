// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct ManagerView: View {
	@ObservedObject var viewModel: ManagerViewModel

	init(viewModel: ManagerViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			Text(viewModel.title)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.accentGrayBackground)
		.edgesIgnoringSafeArea(.all)
	}
}
