// Copyright (c) 2024 by Handbid. All rights reserved.

enum DeviceConfigurator {
	static var isSidebarAlwaysVisible: Bool {
		UIDevice.current.userInterfaceIdiom == .pad
	}
}
