// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

class ServicesDataManager {
	static let shared = ServicesDataManager()
	let userDataManager: DataManager<UserModel>

	init() {
		self.userDataManager = DependencyServiceDataContainer.shared.userDataManager
	}
}

class DependencyServiceDataContainer {
	static let shared = DependencyServiceDataContainer()
	lazy var userDataManager: DataManager<UserModel> = DataManager(dataStore: AnyDataStore(InMemoryDataStore<UserModel>.init()))
}
