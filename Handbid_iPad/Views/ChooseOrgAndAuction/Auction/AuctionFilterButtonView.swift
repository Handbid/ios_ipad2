// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionFilterButtonView: View {
	@Environment(\.colorScheme) var colorScheme
	@ObservedObject var viewModel: AuctionFilterButtonViewModel
	let auctionState: AuctionStateStatuses
	var onSelectionChanged: () -> Void

	var body: some View {
		Button(action: {
			viewModel.isSelected.toggle()
			onSelectionChanged()
		}) {
			HStack {
				Circle()
					.strokeBorder(Color.gray, lineWidth: viewModel.isSelected ? 0 : 1)
					.background(
						Circle().fill(viewModel.isSelected ? auctionState.color(for: colorScheme) : Color.white)
					)
					.frame(width: 30, height: 30)
					.overlay(
						Image(systemName: "checkmark")
							.foregroundColor(viewModel.isSelected ? .white : .clear)
					)
				Text(auctionState.rawValue.capitalized)
					.font(.caption)
					.foregroundColor(colorScheme == .dark ? .white : .black)
			}
		}
	}
}
