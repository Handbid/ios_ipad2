// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import XCTest

final class NetworkingTests: XCTestCase {
	var cancellables = Set<AnyCancellable>()
	var cancellable: Cancellable?

	func testBadURLDoesntCrash() {
		let exp = expectation(description: "call")
		let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
		client.get("/forge a bad url")
			.sink(receiveCompletion: { completion in
			      	switch completion {
			      	case .finished:
			      		print("finished")
			      	case let .failure(error):
			      		if let e = error as? NetworkingError, e.status == .unableToParseRequest {
			      			exp.fulfill()
			      		}
			      		else {
			      			exp.fulfill()
			      		}
			      	}
			      },
			      receiveValue: { (json: Any) in
			      	print(json)
			      }).store(in: &cancellables)
		waitForExpectations(timeout: 1, handler: nil)
	}
}
