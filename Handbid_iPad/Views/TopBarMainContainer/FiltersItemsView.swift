// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct FiltersItemsView: View {
	@ObservedObject var viewModel: AuctionViewModel

	var body: some View {
		ZStack(alignment: .topTrailing) {
			Color(.accent)
				.opacity(0.7)
				.transition(.opacity)

			VStack {
				Spacer()

				Text("Filters")
					.applyTextStyle(style: .subheader)
					.padding(.bottom, 12)

				ScrollView(.vertical) {
					VStack(alignment: .leading) {
						ForEach($viewModel.categories) { category in
							Toggle(isOn: category.isVisible) {
								Text(category.name.wrappedValue ?? "")
									.applyTextStyle(style: .titleLeading)
							}
							.toggleStyle(CheckboxToggleStyle())
						}
					}
				}

				Spacer()
			}
			.frame(width: 300)
			.padding(12)
			.background(in: .rect)
			.backgroundStyle(.white)
			.transition(.move(edge: .trailing))

			Image(.closeIcon)
				.onTapGesture(perform: viewModel.closeOverlay)
				.frame(width: 30, height: 30)
				.padding([.top, .trailing], 28)
		}
	}
}
