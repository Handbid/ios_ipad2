// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad // zamień na właściwą nazwę modułu
import SwiftUI
import ViewInspector
import XCTest

final class LoadingOverlayTests: XCTestCase {
	func testLoadingOverlayIsLoading() throws {
		let isLoading = Binding.constant(true)
		let content = Text("Content")
		let view = LoadingOverlay(isLoading: isLoading) { content }

		let exp = expectation(description: "LoadingOverlay is loading")

		ViewHosting.host(view: view)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			do {
				let inspectedView = try view.inspect()
				XCTAssertNoThrow(try inspectedView.find(LoadingView.self))
				exp.fulfill()
			}
			catch {
				XCTFail("Inspection failed")
			}
		}

		wait(for: [exp], timeout: 0.5)
	}

	func testLoadingOverlayIsNotLoading() throws {
		let isLoading = Binding.constant(false)
		let content = Text("Content")
		let view = LoadingOverlay(isLoading: isLoading) { content }

		let exp = expectation(description: "LoadingOverlay is not loading")

		ViewHosting.host(view: view)

		XCTAssertThrowsError(try view.inspect().find(LoadingView.self))
		exp.fulfill()
		wait(for: [exp], timeout: 0.5)
	}

	func testLoadingOverlayContent() throws {
		let isLoading = Binding.constant(true)
		let content = Text("Content")
		let view = LoadingOverlay(isLoading: isLoading) { content }

		let exp = expectation(description: "LoadingOverlay content")

		ViewHosting.host(view: view)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			do {
				let text = try view.inspect().find(ViewType.Text.self)
				XCTAssertEqual(try text.string(), "Content")
				exp.fulfill()
			}
			catch {
				XCTFail("Inspection failed")
			}
		}

		wait(for: [exp], timeout: 0.5)
	}
}
