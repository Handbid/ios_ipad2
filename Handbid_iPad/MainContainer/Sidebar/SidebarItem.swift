// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SidebarItem: View {
	let isSelected: Bool
	let iconName: String
	let showLockIcon: Bool
	let text: String
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
					Image(systemName: iconName)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.foregroundColor(isSelected ? .white : .primary)

					if showLockIcon {
						Image(systemName: "lock.fill")
							.foregroundColor(isSelected ? .black : .primary)
							.frame(width: 12, height: 16)
							.offset(x: 18, y: 16)
					}
				}
				Text(text)
					.font(.system(size: 11, weight: .regular))
					.foregroundColor(isSelected ? .accentViolet : .primary)
					.lineLimit(1)
			}
			.padding(10)
		}
		.background(Color.clear)
	}
}
