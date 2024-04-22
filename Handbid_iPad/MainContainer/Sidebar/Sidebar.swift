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
				text: LocalizedStringKey("menuBar_label_auction")
			) {
				selectedView = .auction
			}

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "paddleSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_paddle")
			) {
				selectedView = .paddle
			}

			SidebarItem(
				isSelected: selectedView == .myBids,
				iconName: "bidSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_myBids")
			) {
				selectedView = .myBids
			}

			SidebarItem(
				isSelected: selectedView == .manager,
				iconName: "settingsSidebarIcon",
				showLockIcon: true,
				text: LocalizedStringKey("menuBar_label_manager")
			) {
				selectedView = .manager
			}

			Spacer()

			SidebarItem(
				isSelected: selectedView == .logout,
				iconName: "logoutSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_logout")
			) {
				selectedView = .logout
			}
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
