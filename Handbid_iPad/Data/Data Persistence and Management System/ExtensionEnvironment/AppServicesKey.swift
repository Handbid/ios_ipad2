// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

private struct AppServicesKey: EnvironmentKey {
	static let defaultValue: ServicesDataManager = .init()
}

extension EnvironmentValues {
	var appServices: ServicesDataManager {
		get { self[AppServicesKey.self] }
		set { self[AppServicesKey.self] = newValue }
	}
}
