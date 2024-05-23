// Copyright (c) 2024 by Handbid. All rights reserved.

protocol HandshakeResponseProvider {
	func getHandshakeResponse(from: URL) throws -> String
}

class DefaultHandshakeResponseProvider: HandshakeResponseProvider {
	func getHandshakeResponse(from url: URL) throws -> String {
		try String(contentsOf: url, encoding: .utf8)
	}
}
