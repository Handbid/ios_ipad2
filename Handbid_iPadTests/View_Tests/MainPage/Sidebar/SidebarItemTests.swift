// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class SidebarItemTests: XCTestCase {
	func testSidebarItemInitialization() throws {
		let sidebarItem = SidebarItem(
			isSelected: true,
			iconName: "auctionSidebarIcon",
			showLockIcon: false,
			text: LocalizedStringKey("menuBar_label_auction"),
			action: {}
		)

		let vStack = try sidebarItem.inspect().find(ViewType.VStack.self)
		let zStack = try vStack.zStack(0)
		let image = try zStack.image(1)
		XCTAssertEqual(try image.accessibilityLabel().string(), "auctionSidebarIcon")
	}

	func testSidebarItemAction() throws {
		var actionCalled = false
		let sidebarItem = SidebarItem(
			isSelected: false,
			iconName: "auctionSidebarIcon",
			showLockIcon: false,
			text: LocalizedStringKey("menuBar_label_auction")
		) {
			actionCalled = true
		}

		try sidebarItem.inspect().button().tap()
		XCTAssertTrue(actionCalled)
	}

	func testSidebarItemWithLockIcon() throws {
		let sidebarItem = SidebarItem(
			isSelected: true,
			iconName: "settingsSidebarIcon",
			showLockIcon: true,
			text: LocalizedStringKey("menuBar_label_manager"),
			action: {}
		)

		let vStack = try sidebarItem.inspect().find(ViewType.VStack.self)
		let zStack = try vStack.zStack(0)
		let lockIcon = try zStack.image(2)
		XCTAssertEqual(try lockIcon.accessibilityLabel().string(), "lockSidebarIcon")
	}
}
