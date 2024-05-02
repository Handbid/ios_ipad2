// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService

class DependencyMainAppProvider {
	static let shared = DependencyMainAppProvider()

	var networkClient: NetworkingClient {
		NetworkingClient.shared
	}

	let authManager = AuthManager()

	private init() {}
}
