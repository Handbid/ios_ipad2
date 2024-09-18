// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PuzzleButtonView: ButtonItemViewProtocol {
	var item: ItemModel
	let resetTimer: () -> Void
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?
	let auction = try? DataManager.shared.fetchSingle(of: AuctionModel.self, from: .auction)

	var body: some View {
		VStack {
			HStack(spacing: 30) {
				VStack {
					Text("\(item.puzzlePiecesCount ?? 0)")
						.font(.title2)
						.fontWeight(.bold)
					Text(LocalizedStringKey("item_label_piecesLeft"))
						.fontWeight(.medium)
						.font(.subheadline)
				}

				VStack {
					Text("\(item.buyNowPrice ?? 0, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
						.fontWeight(.bold)
						.font(.title2)
					Text(LocalizedStringKey("item_label_pricePerPiece"))
						.fontWeight(.medium)
						.font(.subheadline)
				}
			}

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				resetTimer()
				showPaddleInput = true
				selectedAction = .buyNowPuzzle
			}) {
				Text("\(String(format: NSLocalizedString("item_label_buyPuzzlePieceFor", comment: ""))) \(item.buyNowPrice ?? 0, format: .currency(code: "\(auction?.currencyCode ?? "")"))")
			}
		}
		.padding()
	}
}
