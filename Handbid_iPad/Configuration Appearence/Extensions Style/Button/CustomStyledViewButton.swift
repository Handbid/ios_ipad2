// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

private struct ButtonStyleModifier: ViewModifier {
	let config: ButtonStyleConfiguration

	func body(content: Content) -> some View {
		content
			.font(config.font)
			.foregroundColor(config.foregroundColor)
			.padding()
			.frame(maxWidth: .infinity)
			.background(config.backgroundColor)
			.cornerRadius(config.cornerRadius)
			.overlay(
				RoundedRectangle(cornerRadius: config.cornerRadius)
					.stroke(config.borderColor ?? config.backgroundColor, lineWidth: config.borderWidth)
			)
			.shadow(color: config.shadowColor ?? .clear, radius: config.shadowRadius)
			.padding(config.padding)
	}
}

struct CustomStyledViewButton<ContentLabel>: View where ContentLabel: View {
	let action: () -> Void
	let config: ButtonStyles
	let label: () -> ContentLabel
	@Binding var isDisabled: Bool

	var body: some View {
		Button(action: action) {
			label()
				.contentShape(Rectangle())
				.modifier(ButtonStyleModifier(config: isDisabled ? config.disabledConfiguration : config.configuration))
		}
		.disabled(isDisabled)
	}
}

extension Button {
	static func styled<ContentLabel>(config: ButtonStyles, isDisabled: Binding<Bool> = .constant(false), action: @escaping () -> Void, @ViewBuilder label: @escaping () -> ContentLabel) -> CustomStyledViewButton<ContentLabel> where ContentLabel: View {
		CustomStyledViewButton(action: action, config: config, label: label, isDisabled: isDisabled)
	}
}
