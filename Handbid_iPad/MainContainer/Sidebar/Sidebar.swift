// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct Sidebar: View {
	@Binding var selectedView: MainContainerTypeView
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			SidebarItem(
				isSelected: selectedView == .auction,
				iconName: selectedView == .auction ? "cart.fill" : "cart",
				showLockIcon: false,
				text: "Auction"
			) {
				selectedView = .auction
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: selectedView == .paddle ? "hammer.fill" : "hammer",
				showLockIcon: false,
				text: "Paddle"
			) {
				selectedView = .paddle
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: selectedView == .paddle ? "square.and.arrow.up.fill" : "square.and.arrow.up",
				showLockIcon: false,
				text: "My Bids"
			) {
				selectedView = .paddle
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: selectedView == .paddle ? "person.3.fill" : "person.3",
				showLockIcon: true,
				text: "Manager"
			) {
				selectedView = .paddle
			}

			Spacer()
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
