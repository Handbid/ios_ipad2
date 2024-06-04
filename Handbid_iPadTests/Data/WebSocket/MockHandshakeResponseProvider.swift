// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockHandshakeResponseProvider: HandshakeResponseProvider {
	var response: String?
	var error: Error?

	func getHandshakeResponse(from _: URL) throws -> String {
		if let error {
			throw error
		}
		return response ?? ""
	}
}
