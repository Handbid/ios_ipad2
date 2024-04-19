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
				isSelected: selectedView == .myBids,
				iconName: "bidSidebarIcon",
				showLockIcon: false,
				text: "My Bids"
			) {
				selectedView = .myBids
			}

			SidebarItem(
				isSelected: selectedView == .manager,
				iconName: "settingsSidebarIcon",
				showLockIcon: true,
				text: "Manager"
			) {
				selectedView = .manager
			}

			Spacer()

			SidebarItem(
				isSelected: selectedView == .logout,
				iconName: "logoutSidebarIcon",
				showLockIcon: false,
				text: "Logout"
			) {
				selectedView = .logout
			}
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
