// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CenteredWrappingContainer<Content: View>: View {
	var content: () -> Content
	var portraitWidthFraction: CGFloat = 0.7
	var landscapeWidthFraction: CGFloat = 0.5
	@State private var frameWidthFraction: CGFloat

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.frameWidthFraction = UIDevice.current.orientation.isPortrait ? portraitWidthFraction :
			landscapeWidthFraction
	}

	init(portraitWidthFraction: CGFloat,
	     landscapeWidthFraction: CGFloat,
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
				Spacer(minLength: width * (1 - frameWidthFraction) * 0.5)
				VStack(alignment: .center) {
					Spacer(minLength: height * 0.1)
					content()
						.frame(minWidth: width * 0.33, alignment: .center)
						.background(.white)
						.clipShape(RoundedRectangle(cornerRadius: 40))
					Spacer(minLength: height * 0.1)
				}
				Spacer(minLength: width * (1 - frameWidthFraction) * 0.5)
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
