// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DataManagerEnvironmentKey: EnvironmentKey {
	static let defaultValue: DataManager = .shared
}

extension EnvironmentValues {
	var dataManager: DataManager {
		get { self[DataManagerEnvironmentKey.self] }
		set { self[DataManagerEnvironmentKey.self] = newValue }
	}
}
