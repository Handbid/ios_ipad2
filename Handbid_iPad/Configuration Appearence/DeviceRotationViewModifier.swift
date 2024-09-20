// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
	let action: (UIDeviceOrientation) -> Void

	func body(content: Content) -> some View {
		content
			.onAppear()
			.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
				let orientation = UIDevice.current.orientation
				if orientation.isValidInterfaceOrientation {
					action(orientation)
				}
			}
	}
}
