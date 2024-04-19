// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct Sidebar: View {
	@Binding var selectedView: MainContainerTypeView
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			SidebarItem(
				isSelected: selectedView == .auction,
				iconName: "auctionSidebarIcon",
				showLockIcon: false,
				text: "Auction"
			) {
				selectedView = .auction
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "paddleSidebarIcon",
				showLockIcon: false,
				text: "Paddle"
			) {
				selectedView = .paddle
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "bidSidebarIcon",
				showLockIcon: false,
				text: "My Bids"
			) {
				selectedView = .paddle
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "settingsSidebarIcon",
				showLockIcon: true,
				text: "Manager"
			) {
				selectedView = .paddle
			}

			Spacer()

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "logoutSidebarIcon",
				showLockIcon: false,
				text: "Logout"
			) {
				selectedView = .paddle
			}
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
