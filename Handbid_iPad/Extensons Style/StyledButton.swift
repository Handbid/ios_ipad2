// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI

private struct DefaultButtonStyleConfiguration: ViewModifier {
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

struct StyledButton<ContentLabel>: View where ContentLabel: View {
	let action: () -> Void
	let config: ButtonStyleConfiguration
	let label: () -> ContentLabel

	var body: some View {
		Button(action: action) {
			label()
				.contentShape(Rectangle())
				.modifier(DefaultButtonStyleConfiguration(config: config))
		}
	}
}

extension Button {
	static func styled<ContentLabel>(config: ButtonStyleConfiguration, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> ContentLabel) ->
		StyledButton<ContentLabel> where ContentLabel: View { StyledButton(action: action, config: config, label: label) }
}


extension ButtonStyleConfiguration {
	static let primaryButtonStyle = ButtonStyleConfiguration(
		backgroundColor: .purple,
		foregroundColor: .white,
		borderWidth: 0,
		cornerRadius: 10,
		font: .system(size: 16, weight: .semibold)
	)
}
