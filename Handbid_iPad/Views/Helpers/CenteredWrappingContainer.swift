// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CenteredWrappingContainer<Content: View>: View {
	var content: () -> Content
	var portraitWidthFraction: CGFloat
	var landscapeWidthFraction: CGFloat
	@State private var frameWidthFraction: CGFloat

	init(portraitWidthFraction: CGFloat = 0.7,
	     landscapeWidthFraction: CGFloat = 0.5,
	     @ViewBuilder content: @escaping () -> Content)
	{
		self.content = content
		self.portraitWidthFraction = portraitWidthFraction
		self.landscapeWidthFraction = landscapeWidthFraction
		self.frameWidthFraction = UIDevice.current.orientation.isPortrait ? portraitWidthFraction :
			landscapeWidthFraction
	}

	var body: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			let height = geometry.size.height
			HStack {
				let horizontalMargin = width * (1 - frameWidthFraction) * 0.5

				Spacer(minLength: horizontalMargin)
				VStack(alignment: .center) {
					Spacer(minLength: height * 0.1)
					content()
						.frame(minWidth: width * frameWidthFraction, alignment: .center)
						.background(.white)
						.clipShape(RoundedRectangle(cornerRadius: 40))
					Spacer(minLength: height * 0.1)
				}
				Spacer(minLength: horizontalMargin)
			}
		}.onReceive(NotificationCenter.Publisher(center: .default,
		                                         name: UIDevice.orientationDidChangeNotification))
		{ _ in
			frameWidthFraction = UIDevice.current.orientation.isPortrait ? portraitWidthFraction :
				landscapeWidthFraction
		}.onAppear {
			UIDevice.current.beginGeneratingDeviceOrientationNotifications()
		}.onDisappear {
			UIDevice.current.endGeneratingDeviceOrientationNotifications()
		}
	}
}
