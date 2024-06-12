// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LoadingOverlay<Content: View>: View {
	@Binding var isLoading: Bool
	let content: Content
	var backgroundColor: Color = .black
	var opacity: Double = 0.5

	init(isLoading: Binding<Bool>, backgroundColor: Color = .black, opacity: Double = 0.5, @ViewBuilder content: () -> Content) {
		self._isLoading = isLoading
		self.backgroundColor = backgroundColor
		self.opacity = opacity
		self.content = content()
	}

	var body: some View {
		ZStack {
			content
			if isLoading {
				backgroundColor.opacity(opacity).edgesIgnoringSafeArea(.all)
					.overlay(
						LoadingView(isVisible: $isLoading)
							.accessibilityElement(children: .combine)
							.accessibilityLabel("Loading overlay")
					)
					.allowsHitTesting(true)
			}
		}
	}
}
