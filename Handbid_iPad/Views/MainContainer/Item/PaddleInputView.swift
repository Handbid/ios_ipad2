// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PaddleInputView: View {
	@Binding var isVisible: Bool
	@Binding var valueType: ItemValueType
	@Binding var selectedAction: ActionButtonType?
	@State private var inputText: String = ""
	@State private var activeKey: String? = nil
	@State private var pressedKeys: Set<String> = []
	@StateObject private var viewModel = PaddleInputViewModel()
	let item: ItemModel
	let resetTimer: () -> Void

	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 40) {
				Text("Enter your paddle number")
					.font(.headline)
					.fontWeight(.bold)
					.padding()

				ZStack {
					VStack {
						Text(inputText)
							.frame(height: 30)
							.font(.largeTitle)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .center)

						Rectangle()
							.frame(height: 1)
							.foregroundColor(inputText.isEmpty ? .black : Color.accentViolet)
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
						isVisible = false
						resetTimer()
					}) {
						Text("Cancel")
							.textCase(.uppercase)
					}.accessibilityIdentifier("Cancel")
						.padding(.leading)

					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						viewModel.performAction(for: item, valueType: valueType, selectedAction: selectedAction)
//						isVisible = false
						resetTimer()
					}) {
						Text("Confirm")
							.textCase(.uppercase)
					}.accessibilityIdentifier("Confirm")
						.padding(.trailing)
				}
			}
			.frame(maxWidth: .infinity)
			Spacer()
		}
		.onTapGesture {
			resetTimer()
		}
		.frame(maxHeight: .infinity)
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
			if !inputText.isEmpty {
				inputText.removeLast()
			}
		}
		else if inputText.isEmpty, key == "0" {
			return
		}
		else if inputText.count < 6 {
			inputText.append(key)
		}
	}

	private func animateButtonPress(_ key: String) {
		pressedKeys.insert(key)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			pressedKeys.remove(key)
		}
	}
}
