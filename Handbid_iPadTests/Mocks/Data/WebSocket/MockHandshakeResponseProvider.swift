// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockHandshakeResponseProvider: HandshakeResponseProvider {
	var response = "testResponse:test:test"

	func getHandshakeResponse(from _: URL) throws -> String {
		response
	}
}
