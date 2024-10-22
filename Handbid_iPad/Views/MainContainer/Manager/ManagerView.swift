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
			PickerView(data: TabSection.allCases, selection: $viewModel.selectedTab, style: .noBackground) { section in
				HStack {
					Image(section.iconName)

					Text(section.localizedText)
						.frame(alignment: .leading)
						.font(TypographyStyle.small.asFont())
				}
			}
			.padding(.all, 16)

			ManagerSubViewFactory(viewModel: viewModel)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.containerBackground)
		.edgesIgnoringSafeArea(.all)
		.accessibilityIdentifier("ManagerView")
	}
}
