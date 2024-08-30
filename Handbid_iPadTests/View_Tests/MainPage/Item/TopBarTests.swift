// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

// Mock Content for TopBarContentProtocol
struct MockTopBarContent: TopBarContentProtocol {
	var leftViews: [AnyView] = [
		AnyView(Text("Left 1")),
		AnyView(Text("Left 2")),
	]

	var centerView: AnyView = .init(Text("Center"))

	var rightViews: [AnyView] = [
		AnyView(Text("Right 1")),
		AnyView(Text("Right 2")),
	]
}

final class TopBarTests: XCTestCase {
	func testTopBarContainsLeftViews() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let leftViews = try view.inspect().find(viewWithAccessibilityIdentifier: "LeftViews")
		XCTAssertEqual(try leftViews.accessibilityIdentifier(), "LeftViews")
	}

	func testTopBarContainsCenterView() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let centerView = try view.inspect().find(viewWithAccessibilityIdentifier: "CenterView")
		XCTAssertEqual(try centerView.accessibilityIdentifier(), "CenterView")
	}

	func testTopBarContainsRightViews() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let rightViews = try view.inspect().find(viewWithAccessibilityIdentifier: "RightViews")
		XCTAssertEqual(try rightViews.accessibilityIdentifier(), "RightViews")
	}

	func testLeftViewContent() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let leftView1 = try view.inspect().hStack().hStack(0)
		XCTAssertNotNil(leftView1)

		let leftView2 = try view.inspect().hStack().hStack(0)
		XCTAssertNotNil(leftView2)
	}

	func testRightViewContent() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let rightView1 = try view.inspect().hStack().hStack(2)
		XCTAssertNotNil(rightView1)

		let rightView2 = try view.inspect().hStack().hStack(2)
		XCTAssertNotNil(rightView2)
	}

	func testCenterViewContent() throws {
		let content = MockTopBarContent()
		let view = TopBar(content: content, barHeight: 50)

		let centerView = try view.inspect().hStack().view(CenteredView<AnyView>.self, 1)
		XCTAssertNotNil(centerView)
	}
}
