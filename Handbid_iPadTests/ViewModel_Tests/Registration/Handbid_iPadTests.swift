// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class MockLogInAnonymously: LogInAnonymously {
	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
		let mockVersion = AppVersionModel(demoModeEnabled: 0, id: 1, os: "iOS", appName: "Handbid", minimumVersion: "1.0", currentVersion: "2.0")
		return Just(mockVersion)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}

final class GetStartedViewModelTests: XCTestCase {
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
		XCTAssertEqual(openedURL?.absoluteString, expectedURLString, "Opened URL should match expected value")
	}
}
