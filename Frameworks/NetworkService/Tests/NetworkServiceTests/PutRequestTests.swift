// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import XCTest

@testable
import NetworkService

class PutRequestTests: XCTestCase {
	private let network = NetworkingClient(baseURL: "https://mocked.com")
	private var cancellables = Set<AnyCancellable>()

	override func setUpWithError() throws {
		network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
	}

	override func tearDownWithError() throws {
		MockingURLProtocol.mockedResponse = ""
		MockingURLProtocol.currentRequest = nil
	}

	func testPUTVoidWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{ "response": "OK" }
			"""
		let expectationWorks = expectation(description: "Call works")
		let expectationFinished = expectation(description: "Finished")
		network.put("/users").sink { completion in
			switch completion {
			case .failure:
				XCTFail()
			case .finished:
				XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
				XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
				expectationFinished.fulfill()
			}
		} receiveValue: { () in
			expectationWorks.fulfill()
		}
		.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTVoidAsyncWorks() async throws {
		MockingURLProtocol.mockedResponse =
			"""
			{ "response": "OK" }
			"""
		let _: Void = try await network.put("/users")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
	}

	func testPUTDataWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{ "response": "OK" }
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/users").sink { completion in
			switch completion {
			case .failure:
				XCTFail()
			case .finished:
				XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
				XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
				expectationFinished.fulfill()
			}
		} receiveValue: { (data: Data) in
			XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
			expectationWorks.fulfill()
		}
		.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTDataAsyncWorks() async throws {
		MockingURLProtocol.mockedResponse =
			"""
			{ "response": "OK" }
			"""
		let data: Data = try await network.put("/users")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
		XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
	}

	func testPUTJSONWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{"response":"OK"}
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/users").sink { completion in
			switch completion {
			case .failure:
				XCTFail()
			case .finished:
				XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
				XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
				expectationFinished.fulfill()
			}
		} receiveValue: { (json: Any) in
			let data = try? JSONSerialization.data(withJSONObject: json, options: [])
			let expectedResponseData =
				"""
				{"response":"OK"}
				""".data(using: String.Encoding.utf8)

			XCTAssertEqual(data, expectedResponseData)
			expectationWorks.fulfill()
		}
		.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTJSONAsyncWorks() async throws {
		MockingURLProtocol.mockedResponse =
			"""
			{"response":"OK"}
			"""
		let json: Any = try await network.put("/users")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
		let data = try? JSONSerialization.data(withJSONObject: json, options: [])
		let expectedResponseData =
			"""
			{"response":"OK"}
			""".data(using: String.Encoding.utf8)
		XCTAssertEqual(data, expectedResponseData)
	}

	func testPUTNetworkingJSONDecodableWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{
			    "title":"Hello",
			    "content":"World",
			}
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/posts/1")
			.sink { completion in
				switch completion {
				case .failure:
					XCTFail()
				case .finished:
					XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
					XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/posts/1")
					expectationFinished.fulfill()
				}
			} receiveValue: { (post: Post) in
				XCTAssertEqual(post.title, "Hello")
				XCTAssertEqual(post.content, "World")
				expectationWorks.fulfill()
			}
			.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTDecodableWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{
			    "firstname":"John",
			    "lastname":"Doe",
			}
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/users/1")
			.sink { completion in
				switch completion {
				case .failure:
					XCTFail()
				case .finished:
					XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
					XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
					expectationFinished.fulfill()
				}
			} receiveValue: { (userJSON: UserJSON) in
				XCTAssertEqual(userJSON.firstname, "John")
				XCTAssertEqual(userJSON.lastname, "Doe")
				expectationWorks.fulfill()
			}
			.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTDecodableAsyncWorks() async throws {
		MockingURLProtocol.mockedResponse =
			"""
			{
			    "firstname":"John",
			    "lastname":"Doe",
			}
			"""
		let user: UserJSON = try await network.put("/users/1")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
		XCTAssertEqual(user.firstname, "John")
		XCTAssertEqual(user.lastname, "Doe")
	}

	func testPUTArrayOfDecodableWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			[
			    {
			        "firstname":"John",
			        "lastname":"Doe"
			    },
			    {
			        "firstname":"Jimmy",
			        "lastname":"Punchline"
			    }
			]
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/users")
			.sink { completion in
				switch completion {
				case .failure:
					XCTFail()
				case .finished:
					XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
					XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
					expectationFinished.fulfill()
				}
			} receiveValue: { (userJSON: [UserJSON]) in
				XCTAssertEqual(userJSON[0].firstname, "John")
				XCTAssertEqual(userJSON[0].lastname, "Doe")
				XCTAssertEqual(userJSON[1].firstname, "Jimmy")
				XCTAssertEqual(userJSON[1].lastname, "Punchline")
				expectationWorks.fulfill()
			}
			.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}

	func testPUTArrayOfDecodableAsyncWorks() async throws {
		MockingURLProtocol.mockedResponse =
			"""
			[
			    {
			        "firstname":"John",
			        "lastname":"Doe"
			    },
			    {
			        "firstname":"Jimmy",
			        "lastname":"Punchline"
			    }
			]
			"""
		let users: [UserJSON] = try await network.put("/users")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
		XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
		XCTAssertEqual(users[0].firstname, "John")
		XCTAssertEqual(users[0].lastname, "Doe")
		XCTAssertEqual(users[1].firstname, "Jimmy")
		XCTAssertEqual(users[1].lastname, "Punchline")
	}

	func testPUTArrayOfDecodableWithKeypathWorks() {
		MockingURLProtocol.mockedResponse =
			"""
			{
			"users" :
			    [
			        {
			            "firstname":"John",
			            "lastname":"Doe"
			        },
			        {
			            "firstname":"Jimmy",
			            "lastname":"Punchline"
			        }
			    ]
			}
			"""
		let expectationWorks = expectation(description: "ReceiveValue called")
		let expectationFinished = expectation(description: "Finished called")
		network.put("/users", keypath: "users")
			.sink { completion in
				switch completion {
				case .failure:
					XCTFail()
				case .finished:
					XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
					XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
					expectationFinished.fulfill()
				}
			} receiveValue: { (userJSON: [UserJSON]) in
				XCTAssertEqual(userJSON[0].firstname, "John")
				XCTAssertEqual(userJSON[0].lastname, "Doe")
				XCTAssertEqual(userJSON[1].firstname, "Jimmy")
				XCTAssertEqual(userJSON[1].lastname, "Punchline")
				expectationWorks.fulfill()
			}
			.store(in: &cancellables)
		waitForExpectations(timeout: 0.1)
	}
}
