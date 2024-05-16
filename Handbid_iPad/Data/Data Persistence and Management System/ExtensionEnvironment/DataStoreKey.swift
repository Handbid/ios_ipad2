// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

private struct DataStoreKey: EnvironmentKey {
	static let defaultValue: DataStore = .shared
}

extension EnvironmentValues {
	var dataStore: DataStore {
		get { self[DataStoreKey.self] }
		set { self[DataStoreKey.self] = newValue }
	}
}
