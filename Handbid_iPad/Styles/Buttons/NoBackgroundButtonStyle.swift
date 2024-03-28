// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NoBackgroundButtonStyle: ButtonStyle {
	static let accent = NoBackgroundButtonStyle(textColor: .accent)

	var textColor: Color

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.modifier(BaseButtonSizeModifier())
			.background(.clear)
			.buttonLabelStyle(color: Color(textColor), uppercase: false)
	}
}

struct ButtonStyleConfiguration {
	var backgroundColor: Color
	var foregroundColor: Color
	var borderColor: Color?
	var borderWidth: CGFloat
	var cornerRadius: CGFloat
	var font: Font

	init(
		backgroundColor: Color = .clear,
		foregroundColor: Color = .black,
		borderColor: Color? = nil,
		borderWidth: CGFloat = 0,
		cornerRadius: CGFloat = 0,
		font: Font = .system(size: 16)
	) {
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
		self.borderColor = borderColor
		self.borderWidth = borderWidth
		self.cornerRadius = cornerRadius
		self.font = font
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
	static func styled<ContentLabel>(config: ButtonStyleConfiguration, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> ContentLabel) -> StyledButton<ContentLabel> where ContentLabel: View {
		StyledButton(action: action, config: config, label: label)
	}
}

struct DefaultButtonStyleConfiguration: ViewModifier {
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

extension ButtonStyleConfiguration {
	static let primaryButtonStyle = ButtonStyleConfiguration(
		backgroundColor: .purple,
		foregroundColor: .white,
		borderWidth: 0,
		cornerRadius: 10,
		font: .system(size: 16, weight: .semibold)
	)
}
