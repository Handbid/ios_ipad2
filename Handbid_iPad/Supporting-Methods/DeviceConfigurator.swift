// Copyright (c) 2024 by Handbid. All rights reserved.

import UIKit

enum DeviceConfigurator {
	static var isSidebarAlwaysVisible: Bool {
                UIDevice.current.userInterfaceIdiom == .pad
	}
}
