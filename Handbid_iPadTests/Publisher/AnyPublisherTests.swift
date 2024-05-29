// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import XCTest

class AnyPublisherTests: XCTestCase {
	func testAsyncSuccess() async throws {
		let subject = PassthroughSubject<String, Error>()
		let publisher = subject.eraseToAnyPublisher()

		Task {
			subject.send("Test")
			subject.send(completion: .finished)
		}

		let result = try await publisher.async()
		XCTAssertEqual(result, "Test")
	}

	func testAsyncFailure() async throws {
		let subject = PassthroughSubject<String, Error>()
		let publisher = subject.eraseToAnyPublisher()
		let testError = NSError(domain: "", code: 1, userInfo: nil)

		Task {
			subject.send(completion: .failure(testError))
		}

		do {
			_ = try await publisher.async()
			XCTFail("Expected to throw")
		}
		catch {
			XCTAssertEqual(error as NSError, testError)
		}
	}
}
