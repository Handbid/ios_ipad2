// Copyright (c) 2024 by Handbid. All rights reserved.

class DeviceContext: ObservableObject {
	@Published var isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
	@Published var isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}
