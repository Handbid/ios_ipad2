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
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Auction")
			.accessibility(addTraits: .isButton)
			.accessibility(value: selectedView == .auction ? Text("Selected") : Text(""))

			SidebarItem(
				isSelected: selectedView == .paddle,
				iconName: "paddleSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_paddle")
			) {
				selectedView = .paddle
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Paddle")
			.accessibility(addTraits: .isButton)
			.accessibility(value: selectedView == .paddle ? Text("Selected") : Text(""))

			SidebarItem(
				isSelected: selectedView == .myBids,
				iconName: "bidSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_myBids")
			) {
				selectedView = .myBids
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("My Bids")
			.accessibility(addTraits: .isButton)
			.accessibility(value: selectedView == .myBids ? Text("Selected") : Text(""))

			SidebarItem(
				isSelected: selectedView == .manager,
				iconName: "settingsSidebarIcon",
				showLockIcon: true,
				text: LocalizedStringKey("menuBar_label_manager")
			) {
				selectedView = .manager
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Manager")
			.accessibility(addTraits: .isButton)
			.accessibility(value: selectedView == .manager ? Text("Selected") : Text(""))

			Spacer()

			SidebarItem(
				isSelected: selectedView == .logout,
				iconName: "logoutSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_logout")
			) {
				selectedView = .logout
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Logout")
			.accessibility(addTraits: .isButton)
			.accessibility(value: selectedView == .logout ? Text("Selected") : Text(""))
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
