// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PuzzleButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType

	var body: some View {
		VStack {
			HStack(spacing: 30) {
				VStack {
					Text("\(item.puzzlePiecesCount ?? 0)")
						.font(.title2)
						.fontWeight(.bold)
					Text("Pieces Left")
						.fontWeight(.medium)
						.font(.subheadline)
				}

				VStack {
					Text("\(item.buyNowPrice ?? 0, format: .currency(code: "USD"))")
						.fontWeight(.bold)
						.font(.title2)
					Text("Price per Piece")
						.fontWeight(.medium)
						.font(.subheadline)
				}
			}

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
			}) {
				Text("Buy Puzzle Piece for \(item.buyNowPrice ?? 0, format: .currency(code: "USD"))")
			}
		}
		.padding()
	}
}
