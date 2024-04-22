// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockChooseEnvironmentViewModel: ChooseEnvironmentViewModel {
	@Published var saveEnvironmentCalled = false

	override func saveEnvironment() {
		saveEnvironmentCalled = true
	}
}
