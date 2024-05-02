// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService

class DependencyMainAppProvider {
	static let shared = DependencyMainAppProvider()

	let networkClient = NetworkingClient()
	let authManager = AuthManager()

	private init() {}
}
