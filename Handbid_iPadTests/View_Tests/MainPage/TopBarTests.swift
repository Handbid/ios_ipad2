//// Copyright (c) 2024 by Handbid. All rights reserved.
//
//@testable import Handbid_iPad
//import SwiftUI
//import ViewInspector
//import XCTest
//
//// Mock implementation for TopBarContentProtocol
//struct MockTopBarContent: TopBarContentProtocol {
//	var leftViews: [AnyView]
//	var centerView: AnyView
//	var rightViews: [AnyView]
//}
//
//// Extend TopBar to be inspectable
//extension TopBar: Inspectable {}
//extension CenteredView: Inspectable {}
//
//final class TopBarTests: XCTestCase {
//	func testTopBarLayout() throws {
//		let leftView = AnyView(Text("Left"))
//		let centerView = AnyView(Text("Center"))
//		let rightView = AnyView(Text("Right"))
//
//		let content = MockTopBarContent(leftViews: [leftView], centerView: centerView, rightViews: [rightView])
//		let topBar = TopBar(content: content, barHeight: 50)
//		let inspectedTopBar = try topBar.inspect()
//
//		// Check the overall layout
//		XCTAssertNoThrow(try inspectedTopBar.hStack())
//
//		// Check left views
//		let leftViews = try inspectedTopBar.hStack().hStack(0).hStack(0)
//		XCTAssertEqual(try leftViews.text(0).string(), "Left")
//
//		// Check center view
//		let centerViewInspection = try inspectedTopBar.hStack().view(CenteredView<AnyView>.self, 1)
//		XCTAssertEqual(try centerViewInspection.hStack().text(1).string(), "Center")
//
//		// Check right views
//		let rightViews = try inspectedTopBar.hStack().hStack(2).hStack(0)
//		XCTAssertEqual(try rightViews.text(0).string(), "Right")
//	}
//
//	func testBarHeight() throws {
//		let content = MockTopBarContent(leftViews: [], centerView: AnyView(EmptyView()), rightViews: [])
//		let barHeight: CGFloat = 0
//		let topBar = TopBar(content: content, barHeight: barHeight)
//
//		let expectation = XCTestExpectation(description: "Wait for frame to be set")
//
//		let hostingController = UIHostingController(rootView: topBar.onPreferenceChange(SizePreferenceKey.self) { size in
//			XCTAssertEqual(size.height, barHeight)
//			expectation.fulfill()
//		})
//
//		let window = UIWindow()
//		window.rootViewController = hostingController
//		window.makeKeyAndVisible()
//
//		wait(for: [expectation], timeout: 1.0)
//	}
//
//	func testLeftViews() throws {
//		let leftView1 = AnyView(Text("Left1"))
//		let leftView2 = AnyView(Text("Left2"))
//
//		let content = MockTopBarContent(leftViews: [leftView1, leftView2], centerView: AnyView(EmptyView()), rightViews: [])
//		let topBar = TopBar(content: content, barHeight: 50)
//		let inspectedTopBar = try topBar.inspect()
//
//		let leftViews = try inspectedTopBar.hStack().hStack(0).hStack(0)
//		XCTAssertEqual(try leftViews.text(0).string(), "Left1")
//		XCTAssertEqual(try leftViews.text(1).string(), "Left2")
//	}
//
//	func testRightViews() throws {
//		let rightView1 = AnyView(Text("Right1"))
//		let rightView2 = AnyView(Text("Right2"))
//
//		let content = MockTopBarContent(leftViews: [], centerView: AnyView(EmptyView()), rightViews: [rightView1, rightView2])
//		let topBar = TopBar(content: content, barHeight: 50)
//		let inspectedTopBar = try topBar.inspect()
//
//		let rightViews = try inspectedTopBar.hStack().hStack(2).hStack(0)
//		XCTAssertEqual(try rightViews.text(0).string(), "Right1")
//		XCTAssertEqual(try rightViews.text(1).string(), "Right2")
//	}
//
//	func testCenterView() throws {
//		let centerView = AnyView(Text("Center"))
//
//		let content = MockTopBarContent(leftViews: [], centerView: centerView, rightViews: [])
//		let topBar = TopBar(content: content, barHeight: 50)
//		let inspectedTopBar = try topBar.inspect()
//
//		let centerViewInspection = try inspectedTopBar.hStack().view(CenteredView<AnyView>.self, 1)
//		XCTAssertEqual(try centerViewInspection.hStack().text(1).string(), "Center")
//	}
//}
//
//// PreferenceKey to get the size of a view
//struct SizePreferenceKey: PreferenceKey {
//	typealias Value = CGSize
//	static var defaultValue: CGSize = .zero
//	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//		value = nextValue()
//	}
//}
