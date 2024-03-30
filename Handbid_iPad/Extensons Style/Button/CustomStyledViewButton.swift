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
	}
}

struct CustomStyledViewButton<ContentLabel>: View where ContentLabel: View {
	let action: () -> Void
	let config: ButtonStyles
	let label: () -> ContentLabel

	var body: some View {
		Button(action: action) {
			label()
				.contentShape(Rectangle())
				.modifier(ButtonStyleModifier(config: config.configuration))
		}
	}
}

extension Button {
	static func styled<ContentLabel>(config: ButtonStyles, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> ContentLabel) ->
		CustomStyledViewButton<ContentLabel> where ContentLabel: View { CustomStyledViewButton(action: action, config: config, label: label) }
}
