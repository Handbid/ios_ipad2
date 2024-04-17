// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockLogInAnonymously: LogInAnonymously {
	func logInAnonymously() -> AnyPublisher<AppVersionModel, Error> {
		let mockVersion = AppVersionModel(demoModeEnabled: 0, id: 1, os: "iOS", appName: "Handbid", minimumVersion: "1.0", currentVersion: "2.0")
		return Just(mockVersion)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}
