// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

class MockViewModel: ViewModelTopBarProtocol {
	var centerViewData = TopBarCenterViewData(type: .title, title: "Mock Title", image: nil, customView: nil)
	var actions: [TopBarAction] = [
		TopBarAction(icon: "actionIcon", title: "Action", action: {}),
	]
}

final class GenericTopBarContentAccessibilityTests: XCTestCase {
	func testMenuButtonAccessibilityLabel() throws {
		let viewModel = MockViewModel()
		let topBarContent = GenericTopBarContent(isSidebarVisible: .constant(false), viewModel: viewModel)

		let menuButton = try topBarContent.inspect().find(button: "menuIcon")
		XCTAssertEqual(try menuButton.accessibilityLabel().string(), "Menu Button")
	}

	func testCenterViewAccessibilityLabel() throws {
		let viewModel = MockViewModel()
		let topBarContent = GenericTopBarContent(isSidebarVisible: .constant(false), viewModel: viewModel)

		let centerView = try topBarContent.inspect().find(text: "Mock Title")
		XCTAssertEqual(try centerView.accessibilityLabel().string(), "Mock Title")
	}

	func testActionButtonAccessibilityLabel() throws {
		let viewModel = MockViewModel()
		let topBarContent = GenericTopBarContent(isSidebarVisible: .constant(false), viewModel: viewModel)

		let actionButton = try topBarContent.inspect().find(button: "actionIcon")
		XCTAssertEqual(try actionButton.accessibilityLabel().string(), "Action")
	}
}
