// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension View {
	func backgroundImageView(for image: BackgroundContainerImage) -> some View {
		Image(image.rawValue)
			.resizable()
			.scaledToFill()
			.edgesIgnoringSafeArea(.all)
	}

	func backgroundView(for background: BackgroundContainer) -> some View {
		switch background {
		case let .image(image):
			AnyView(Image(image.rawValue)
				.resizable()
				.scaledToFill()
				.edgesIgnoringSafeArea(.all))
		case let .color(color):
			AnyView(color.edgesIgnoringSafeArea(.all))
		}
	}

	func backButtonNavigation(style: NavigationBackButtonStyle) -> some View {
		modifier(NavigationBackButtonModifier(style: style))
	}

	func keyboardResponsive() -> some View {
		modifier(KeyboardResponsiveModifier())
	}

	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}

	func eraseToAnyView() -> AnyView {
		AnyView(self)
	}

	func createGridItems(width: CGFloat, targetWidth: CGFloat) -> [GridItem] {
		let numberOfColumns = max(Int(width / targetWidth), 1)
		return Array(repeating: GridItem(.fixed(targetWidth), spacing: 20), count: numberOfColumns)
	}

	func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
		modifier(DeviceRotationViewModifier(action: action))
	}
}
