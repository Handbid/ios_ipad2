// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService

class MockWebSocketURLFactory: WebSocketURLFactory {
	var url: URL?
	var error: Error?

	func getSocketURL() throws -> URL {
		if let error {
			throw error
		}
		return url!
	}
}
