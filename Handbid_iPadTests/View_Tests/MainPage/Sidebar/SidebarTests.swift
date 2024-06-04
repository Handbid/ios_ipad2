// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class SidebarTests: XCTestCase {
	func testInitialSelectedView() throws {
		let selectedView = Binding<MainContainerTypeView>(wrappedValue: .auction)
		let sidebar = Sidebar(selectedView: selectedView)

		let item = try sidebar.inspect().vStack().view(SidebarItem.self, 0)
		XCTAssertTrue(try item.actualView().isSelected)
	}

	func testSelectPaddleView() throws {
		let selectedView = Binding<MainContainerTypeView>(wrappedValue: .auction)
		let sidebar = Sidebar(selectedView: selectedView)

		let item = try sidebar.inspect().vStack().view(SidebarItem.self, 1)
		try item.button().tap()
		XCTAssertEqual(selectedView.wrappedValue, .paddle)
	}

	func testMyBidsView() throws {
		let selectedView = Binding<MainContainerTypeView>(wrappedValue: .auction)
		let sidebar = Sidebar(selectedView: selectedView)

		let item = try sidebar.inspect().vStack().view(SidebarItem.self, 2)
		try item.button().tap()
		XCTAssertEqual(selectedView.wrappedValue, .myBids)
	}

	func testManagerViewShowsLockIcon() throws {
		let selectedView = Binding<MainContainerTypeView>(wrappedValue: .auction)
		let sidebar = Sidebar(selectedView: selectedView)

		let item = try sidebar.inspect().vStack().view(SidebarItem.self, 3)
		try item.button().tap()
		XCTAssertEqual(selectedView.wrappedValue, .manager)
	}

	func testLogoutViewSelection() throws {
		let selectedView = Binding<MainContainerTypeView>(wrappedValue: .auction)
		let sidebar = Sidebar(selectedView: selectedView)

		let item = try sidebar.inspect().vStack().view(SidebarItem.self, 5)
		try item.button().tap()
		XCTAssertEqual(selectedView.wrappedValue, .logout)
	}
}
