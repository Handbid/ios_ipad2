// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService

class MockChooseEnvironment {
	var saveEnvironmentCalled = false
	var savedEnvironment: AppEnvironmentType?

	func saveEnvironment(_ environment: AppEnvironmentType) {
		saveEnvironmentCalled = true
		savedEnvironment = environment
	}
}
