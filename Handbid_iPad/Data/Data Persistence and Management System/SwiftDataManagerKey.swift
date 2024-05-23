// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SwiftDataManagerKey: EnvironmentKey {
	static let defaultValue: SwiftDataManager = .shared
}

extension EnvironmentValues {
	var swiftDataManager: SwiftDataManager {
		get { self[SwiftDataManagerKey.self] }
		set { self[SwiftDataManagerKey.self] = newValue }
	}
}
