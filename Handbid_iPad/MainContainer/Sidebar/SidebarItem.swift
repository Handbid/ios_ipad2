// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SidebarItem: View {
	let isSelected: Bool
	let iconName: String
	let showLockIcon: Bool
	let text: LocalizedStringKey
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			VStack {
				ZStack {
					Circle()
						.fill(isSelected ? Color.accentViolet : Color.clear)
						.frame(width: 50, height: 50)
						.overlay(
							Circle()
								.stroke(Color.accentGrayForm, lineWidth: isSelected ? 0 : 1)
						)
						.scaleEffect(isSelected ? 1.1 : 1)
						.animation(.spring(), value: isSelected)

					Image(iconName)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.foregroundColor(isSelected ? .white : .primary)
						.rotationEffect(isSelected ? .degrees(360) : .degrees(0))
						.animation(.easeInOut, value: isSelected)
						.accessibilityLabel(iconName)

					if showLockIcon {
						Image("lockSidebarIcon")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 12, height: 16)
							.foregroundColor(isSelected ? .white : .primary)
							.offset(x: 18, y: 16)
							.animation(.easeInOut, value: isSelected)
							.accessibilityLabel("lockSidebarIcon")
					}
				}
				Text(text)
					.font(.system(size: 11, weight: .regular))
					.foregroundColor(.primary)
					.lineLimit(1)
					.accessibilityLabel(text)
			}
			.padding(10)
		}
		.accessibilityElement(children: .combine)
		.accessibility(addTraits: .isButton)
		.accessibility(value: isSelected ? Text("Selected") : Text(""))
		.background(Color.clear)
		.scaleEffect(isSelected ? 1.1 : 1)
		.animation(.spring(), value: isSelected)
	}
}
