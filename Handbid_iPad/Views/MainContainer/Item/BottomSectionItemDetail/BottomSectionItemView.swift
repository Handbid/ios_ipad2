// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct BottomSectionItemView: View {
	@StateObject private var viewModel: BottomSectionItemViewModel
	@Binding var valueType: ItemValueType
	@Binding var showPaddleInput: Bool
	let resetTimer: () -> Void

	init(item: ItemModel, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>, valueType: Binding<ItemValueType>) {
		self._viewModel = StateObject(wrappedValue: BottomSectionItemViewModel(item: item))
		self.resetTimer = resetTimer
		self._showPaddleInput = showPaddleInput
		self._valueType = valueType
	}

	var body: some View {
		VStack(spacing: 10) {
			if case .none = viewModel.valueType {}
			else {
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

			ButtonSectionItemFactory.createButtonView(for: viewModel.item, valueType: $viewModel.valueType, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
		}
		.onTapGesture {
			resetTimer()
		}
		.onChange(of: viewModel.valueType) { newValue in
			valueType = newValue
		}
	}
}
