// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

final class TopBarContentFactoryTests: XCTestCase {
	func testCreateTopBarContent() throws {
		struct MockFactory: TopBarContentFactory {
			typealias ViewModelType = MockViewModel
			var viewModel: MockViewModel
		}

		let factory = MockFactory(viewModel: MockViewModel())
		let isSidebarVisible = Binding<Bool>(wrappedValue: false)
		let topBarContent = factory.createTopBarContent(isSidebarVisible: isSidebarVisible)

		XCTAssertNotNil(topBarContent as? GenericTopBarContent<MockViewModel>)
	}
}

final class TopBarCenterViewDataTests: XCTestCase {
	func testCenterViewDataInitialization() {
		let data = TopBarCenterViewData(type: .title, title: "Title", image: nil, customView: nil)
		XCTAssertEqual(data.type, .title)
		XCTAssertEqual(data.title, "Title")
		XCTAssertNil(data.image)
		XCTAssertNil(data.customView)
	}
}

final class TopBarActionTests: XCTestCase {
	func testTopBarActionInitialization() {
		let action = TopBarAction(icon: "icon", title: "Title") {}
		XCTAssertEqual(action.icon, "icon")
		XCTAssertEqual(action.title, "Title")
	}
}
