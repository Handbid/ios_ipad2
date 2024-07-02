// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct BottomSectionItemView: View {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool

	@State private var valueType: ItemValueType = .bidAmount(99.99)
	private let initialBidAmount: Double = 99.99

	var body: some View {
		VStack(spacing: 10) {
			ZStack {
				TopViewOfBottomSectionItemFactory.createValueView(for: item, valueType: $valueType, resetTimer: resetTimer, initialBidAmount: initialBidAmount)
			}
			.frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
			.background(Color.white)
			.cornerRadius(25)
			.overlay(
				RoundedRectangle(cornerRadius: 25)
					.stroke(Color.accentGrayBorder, lineWidth: 2)
			)
			.padding([.leading, .trailing], 20)
			.padding(.top, 10)

			ButtonSectionItemFactory.createButtonView(for: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
		}
		.onTapGesture {
			resetTimer()
		}
	}
}
