// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService
import SwiftUI
import ViewInspector
import XCTest

final class MainContainerTests: XCTestCase {
	private var view: MainContainer<MainContainerPage>!
	private var coordinator: Coordinator<MainContainerPage, Any?>!
	private var authManager: AuthManager!
	private var mainContainerFactory: AnyViewMainContainerFactory!
	private var sut: AnyView!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<MainContainerPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		authManager = AuthManager()
		mainContainerFactory = AnyViewMainContainerFactory(wrappedFactory: MainContainerViewFactory())
		view = MainContainer(selectedView: .auction)
		sut = AnyView(view
			.environmentObject(coordinator)
			.environmentObject(authManager)
			.environmentObject(mainContainerFactory))
	}

	override func tearDown() {
		coordinator = nil
		authManager = nil
		mainContainerFactory = nil
		view = nil
		super.tearDown()
	}

	func testInitialContent() throws {
		var inspectionError: Error? = nil

		ViewHosting.host(view: sut)
		do {
			_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")
			// _ = try sut.inspect().find(viewWithAccessibilityIdentifier: "phoneView")
			_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "tabletView")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testTabletViewContent() throws {
		view.deviceContext.isPhone = false

		ViewHosting.host(view: sut)
		let tabletView = try sut.inspect().find(viewWithAccessibilityIdentifier: "tabletView")

		XCTAssertNotNil(tabletView)
	}

	func testMainContainerContent() throws {
		ViewHosting.host(view: sut)
		let mainContainer = try sut.inspect().find(viewWithAccessibilityIdentifier: "mainContainer")

		XCTAssertNotNil(mainContainer)
	}

	func testSidebarHidden() throws {
		view.isSidebarVisible = false

		ViewHosting.host(view: sut)
		let mainContainer = try sut.inspect().find(viewWithAccessibilityIdentifier: "mainContainer")
		let sidebar = try? sut.inspect().find(viewWithAccessibilityIdentifier: "sidebar")

		XCTAssertNotNil(mainContainer)
		XCTAssertNil(sidebar)
	}

	func testTopBarContentForAuction() throws {
		view.selectedView = .auction

		ViewHosting.host(view: sut)
		let topBar = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")

		XCTAssertNotNil(topBar)
	}

	func testTopBarContentForPaddle() throws {
		view.selectedView = .paddle

		ViewHosting.host(view: sut)
		let topBar = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")

		XCTAssertNotNil(topBar)
	}

	func testTopBarContentForMyBids() throws {
		view.selectedView = .myBids

		ViewHosting.host(view: sut)
		let topBar = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")

		XCTAssertNotNil(topBar)
	}

	func testTopBarContentForManager() throws {
		view.selectedView = .manager

		ViewHosting.host(view: sut)
		let topBar = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")

		XCTAssertNotNil(topBar)
	}

	func testTopBarContentForLogout() throws {
		view.selectedView = .logout

		ViewHosting.host(view: sut)
		let topBar = try sut.inspect().find(viewWithAccessibilityIdentifier: "topBar")

		XCTAssertNotNil(topBar)
	}
}
