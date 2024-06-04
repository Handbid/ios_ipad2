// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LoadingOverlay<Content: View>: View {
	@Binding var isLoading: Bool
	let content: Content
	var backgroundColor: Color = .black
	var opactity: Double = 0.5

	init(isLoading: Binding<Bool>,
	     backgroundColor: Color? = .black,
	     opactity: Double? = 0.5,
	     @ViewBuilder content: () -> Content)
	{
		self._isLoading = isLoading

		if let bgColor = backgroundColor {
			self.backgroundColor = bgColor
		}

		if let opacity = opactity {
			self.opactity = opacity
		}

		self.content = content()
	}

	var body: some View {
		ZStack {
			content
			if isLoading {
				backgroundColor.opacity(opactity).edgesIgnoringSafeArea(.all)
					.overlay(
						LoadingView(isVisible: $isLoading)
					)
					.allowsHitTesting(true)
			}
		}
	}
}
