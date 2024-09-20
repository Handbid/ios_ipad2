// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleInputView: View {
	@Binding var isVisible: Bool
	@Binding var showPaddleInput: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?
	@State private var activeKey: String? = nil
	@State private var pressedKeys: Set<String> = []
	@StateObject var viewModel: PaddleInputViewModel
	let item: ItemModel
	let resetTimer: () -> Void

	init(
		isVisible: Binding<Bool>,
		showPaddleInput: Binding<Bool>,
		valueType: Binding<ItemValueType>,
		selectedAction: Binding<ActionButtonType?>,
		item: ItemModel,
		resetTimer: @escaping () -> Void,
		viewModel: PaddleInputViewModel = PaddleInputViewModel()
	) {
		self._isVisible = isVisible
		self._showPaddleInput = showPaddleInput
		self._valueType = valueType
		self._selectedAction = selectedAction
		self.item = item
		self.resetTimer = resetTimer
		self._viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 40) {
				Text(LocalizedStringKey("item_label_enterYouPadle"))
					.font(.headline)
					.fontWeight(.bold)
					.padding()

				ZStack {
					VStack {
						Text(viewModel.inputText)
							.frame(height: 30)
							.font(.largeTitle)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .center)

						Rectangle()
							.frame(height: 1)
							.foregroundColor(viewModel.inputText.isEmpty ? .black : Color.accentViolet)
							.frame(maxWidth: .infinity, alignment: .center)
							.padding([.leading, .trailing], 60)
					}
					.padding([.leading, .trailing], 40)
				}

				VStack(spacing: 20) {
					ForEach(["1 2 3", "4 5 6", "7 8 9", "0 ⌫"], id: \.self) { row in
						HStack(spacing: 20) {
							ForEach(row.split(separator: " "), id: \.self) { key in
								Button(action: {
									handleKeyPress(String(key))
									animateButtonPress(String(key))
									resetTimer()
								}) {
									Text(key)
										.font(.headline)
										.frame(width: 80, height: 80)
										.fontWeight(.medium)
										.background(Color.white)
										.foregroundColor(.black)
										.clipShape(Circle())
										.overlay(
											Circle()
												.stroke(pressedKeys.contains(String(key)) ? Color.accentViolet : Color.accentGrayBorder, lineWidth: 1)
										)
								}
							}
						}
					}
				}
				.padding(.bottom, 0)

				HStack {
					Button<Text>.styled(config: .thirdButtonStyle, action: {
						showPaddleInput = false
						resetTimer()
					}) {
						Text(LocalizedStringKey("item_label_cancel"))
							.textCase(.uppercase)
					}
					.accessibilityIdentifier("Cancel")
					.padding(.leading)

					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						viewModel.performAction(for: item, valueType: valueType, selectedAction: selectedAction)
						showPaddleInput = false
						resetTimer()
					}) {
						Text(LocalizedStringKey("item_label_confirm"))
							.textCase(.uppercase)
					}
					.accessibilityIdentifier("Confirm")
					.padding(.trailing)
				}
			}
			.frame(maxWidth: .infinity)
			Spacer()
		}
		.onTapGesture {
			resetTimer()
		}
		.background(Color.white)
		.frame(maxHeight: .infinity)
		.alert(isPresented: $viewModel.showError) {
			Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
		}
	}

	private func displayValueType() -> String {
		switch valueType {
		case let .bidAmount(value):
			"$\(value)"
		case let .buyNow(value):
			"$\(value)"
		case let .quantity(value):
			"\(value)"
		case .none:
			"None"
		}
	}

	private func handleKeyPress(_ key: String) {
		if key == "⌫" {
			if !viewModel.inputText.isEmpty {
				viewModel.inputText.removeLast()
			}
		}
		else if viewModel.inputText.isEmpty, key == "0" {
			return
		}
		else if viewModel.inputText.count < 6 {
			viewModel.inputText.append(key)
		}
	}

	private func animateButtonPress(_ key: String) {
		pressedKeys.insert(key)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			pressedKeys.remove(key)
		}
	}
}
