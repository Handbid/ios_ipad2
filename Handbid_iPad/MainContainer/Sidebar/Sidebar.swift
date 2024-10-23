// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct Sidebar: View {
	@EnvironmentObject var mainContainerViewModel: MainContainerViewModel
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			SidebarItem(
				isSelected: mainContainerViewModel.selectedView == .auction,
				iconName: "auctionSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_auction")
			) {
				mainContainerViewModel.selectedView = .auction
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Auction")
			.accessibility(addTraits: .isButton)
			.accessibility(value: mainContainerViewModel.selectedView == .auction ?
				Text("Selected") : Text(""))

			SidebarItem(
				isSelected: mainContainerViewModel.selectedView == .paddle,
				iconName: "paddleSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_paddle")
			) {
				mainContainerViewModel.selectedView = .paddle
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Paddle")
			.accessibility(addTraits: .isButton)
			.accessibility(value: mainContainerViewModel.selectedView == .paddle ?
				Text("Selected") : Text(""))

			SidebarItem(
				isSelected: mainContainerViewModel.selectedView == .myBids,
				iconName: "bidSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_myBids")
			) {
				mainContainerViewModel.selectedView = .myBids
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("My Bids")
			.accessibility(addTraits: .isButton)
			.accessibility(value: mainContainerViewModel.selectedView == .myBids ?
				Text("Selected") : Text(""))

			SidebarItem(
				isSelected: mainContainerViewModel.selectedView == .manager,
				iconName: "settingsSidebarIcon",
				showLockIcon: true,
				text: LocalizedStringKey("menuBar_label_manager")
			) {
				AlertManager.shared.showAlert(
					AlertFactory.createAlert(
						type: .enterPin(delegate: mainContainerViewModel)
					)
				)

				mainContainerViewModel.selectedView = .manager
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Manager")
			.accessibility(addTraits: .isButton)
			.accessibility(value: mainContainerViewModel.selectedView == .manager ?
				Text("Selected") : Text(""))

			Spacer()

			SidebarItem(
				isSelected: mainContainerViewModel.selectedView == .logout,
				iconName: "logoutSidebarIcon",
				showLockIcon: false,
				text: LocalizedStringKey("menuBar_label_logout")
			) {
				mainContainerViewModel.selectedView = .logout
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel("Logout")
			.accessibility(addTraits: .isButton)
			.accessibility(value: mainContainerViewModel.selectedView == .logout ?
				Text("Selected") : Text(""))
		}
		.padding(10)
		.background(Color(UIColor.systemBackground))
	}
}
