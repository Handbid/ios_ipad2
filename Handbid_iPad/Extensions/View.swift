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
}
