// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad

class MockMyBidsViewModel: MyBidsViewModel {
	init() {
		super.init(dataService: DataServiceWrapper(wrappedService: MockDataService()))
	}
}
