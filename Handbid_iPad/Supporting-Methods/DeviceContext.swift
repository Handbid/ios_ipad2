// Copyright (c) 2024 by Handbid. All rights reserved.

import UIKit

class DeviceContext: ObservableObject {
	@Published var isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
	@Published var isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}
