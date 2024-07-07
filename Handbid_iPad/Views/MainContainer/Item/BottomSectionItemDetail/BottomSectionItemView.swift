// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct BottomSectionItemView: View {
	@StateObject private var viewModel: BottomSectionItemViewModel
	@Binding var valueType: ItemValueType
	@Binding var showPaddleInput: Bool
	@Binding var selectedAction: ActionButtonType?
	let resetTimer: () -> Void

	init(item: ItemModel, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>, valueType: Binding<ItemValueType>, selectedAction: Binding<ActionButtonType?>) {
		self._viewModel = StateObject(wrappedValue: BottomSectionItemViewModel(item: item))
		self._showPaddleInput = showPaddleInput
		self._valueType = valueType
		self.resetTimer = resetTimer
		self._selectedAction = selectedAction
	}

	var body: some View {
		VStack(spacing: 10) {
			if case .none = viewModel.valueType {}
			else if viewModel.item.itemType == .placeOrder || viewModel.item.itemType == .normal || viewModel.item.itemType == .buyNow || viewModel.item.itemIsAppealAndForSale() || viewModel.item.itemType == .directPurchase {
				ZStack {
					TopViewOfBottomSectionItemFactory.createValueView(for: viewModel.item, valueType: $viewModel.valueType, resetTimer: resetTimer)
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
			}

			ButtonSectionItemFactory.createButtonView(for: viewModel.item, valueType: $viewModel.valueType, resetTimer: resetTimer, showPaddleInput: $showPaddleInput, selectedAction: $selectedAction)
		}
		.onTapGesture {
			resetTimer()
		}
		.onChange(of: viewModel.valueType) { newValue in
			valueType = newValue
		}
	}
}
