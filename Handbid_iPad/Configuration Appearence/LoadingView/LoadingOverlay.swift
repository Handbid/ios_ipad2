// Copyright (c) 2024 by Handbid. All rights reserved.

// Copyright (c) 2024 by Handbid. All rights reserved.
import SwiftUI

struct LoadingOverlay<Content: View>: View {
	@Binding var isLoading: Bool
	let content: Content

	init(isLoading: Binding<Bool>, @ViewBuilder content: () -> Content) {
		self._isLoading = isLoading
		self.content = content()
	}

	var body: some View {
		ZStack {
			content
			if isLoading {
				Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
					.overlay(
						LoadingView(isVisible: $isLoading)
					)
					.allowsHitTesting(true)
			}
		}
	}
}
