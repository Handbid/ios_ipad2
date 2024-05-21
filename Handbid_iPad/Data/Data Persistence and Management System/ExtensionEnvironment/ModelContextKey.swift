// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

private struct ModelContextKey: EnvironmentKey {
	static let defaultValue: ModelContext? = nil
}

extension EnvironmentValues {
	var modelContext: ModelContext? {
		get { self[ModelContextKey.self] }
		set { self[ModelContextKey.self] = newValue }
	}
}
