// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

final class GetStartedViewModel_Tests: XCTestCase {
	var viewModel: GetStartedViewModel!
	var mockRepository: MockLogInAnonymously!

	override func setUp() {
		super.setUp()
		mockRepository = MockLogInAnonymously()
		viewModel = GetStartedViewModel(repository: mockRepository)
	}

	override func tearDown() {
		viewModel = nil
		mockRepository = nil
		super.tearDown()
	}

	func logInAnonymously() {
		viewModel.logInAnonymously()
	}

	func testOpenHandbidWebsite() {
		let expectedURLString = AppInfoProvider.aboutHandbidLink
		var openedURL: URL?

		viewModel.openHandbidWebsite()
		if let url = URL(string: expectedURLString) {
			openedURL = url
		}

		XCTAssertNotNil(openedURL, "Opened URL should not be nil")
	}
}
