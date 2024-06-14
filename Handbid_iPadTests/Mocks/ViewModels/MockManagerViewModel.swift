// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockManagerViewModel: ManagerViewModel {
	init() {
		super.init(dataService: DataServiceWrapper(wrappedService: MockDataService()))
	}
}
