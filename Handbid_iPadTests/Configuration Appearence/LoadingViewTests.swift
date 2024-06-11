// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad // zamień na właściwą nazwę modułu
import ProgressIndicatorView
import SwiftUI
import ViewInspector
import XCTest

final class LoadingViewTests: XCTestCase {
	func testLoadingViewIsVisible() throws {
		let isVisible = Binding.constant(true)
		let view = LoadingView(isVisible: isVisible)

		let exp = expectation(description: "LoadingView is visible")

		ViewHosting.host(view: view)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			do {
				let inspectedView = try view.inspect()
				XCTAssertNoThrow(try inspectedView.find(ProgressIndicatorView.self))
				exp.fulfill()
			}
			catch {
				XCTFail("Inspection failed")
			}
		}

		wait(for: [exp], timeout: 0.5)
	}

	func testLoadingViewIsNotVisible() throws {
		let isVisible = Binding.constant(false)
		let view = LoadingView(isVisible: isVisible)

		let exp = expectation(description: "LoadingView is not visible")

		ViewHosting.host(view: view)

		XCTAssertThrowsError(try view.inspect().find(ProgressIndicatorView.self))
		exp.fulfill()
		wait(for: [exp], timeout: 0.5)
	}

	func testLoadingViewAccessibility() throws {
		let isVisible = Binding.constant(true)
		let view = LoadingView(isVisible: isVisible)

		let exp = expectation(description: "LoadingView accessibility")

		ViewHosting.host(view: view)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			do {
				let progressView = try view.inspect().find(ProgressIndicatorView.self)
				XCTAssertEqual(try progressView.accessibilityLabel().string(), "Loading")
				XCTAssertEqual(try progressView.accessibilityValue().string(), "0 percent complete")
				exp.fulfill()
			}
			catch {
				XCTFail("Inspection failed")
			}
		}

		wait(for: [exp], timeout: 0.5)
	}
}
