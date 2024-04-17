// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockGetStartedViewModel: GetStartedViewModel {
	@Published var handbidWebsiteOpened = false
	@Published var loggedInAnonymously = false

	init() {
		super.init(repository: MockLogInAnonymously())
	}

	override func openHandbidWebsite() {
		handbidWebsiteOpened = true
	}

	override func logInAnonymously() {
		loggedInAnonymously = true
	}
}
