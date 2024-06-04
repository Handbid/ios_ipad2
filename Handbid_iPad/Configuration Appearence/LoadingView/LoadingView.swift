// Copyright (c) 2024 by Handbid. All rights reserved.

import ProgressIndicatorView
import SwiftUI

struct LoadingView: View {
	@Binding var isVisible: Bool
	@State private var progress: CGFloat = 0.0

	var body: some View {
		ZStack {
			if isVisible {
				ProgressIndicatorView(isVisible: $isVisible, type: .default(progress: $progress))
					.frame(width: 100.0, height: 100.0)
					.foregroundColor(.accentViolet)
					.onAppear {
						startLoadingAnimation()
					}
			}
		}
	}

	private func startLoadingAnimation() {
		progress = 0.0
		animateProgress()
	}

	private func animateProgress() {
		guard isVisible else { return }

		withAnimation(.linear(duration: 0.1)) {
			progress += 0.1
			if progress > 1.0 {
				progress = 0.0
			}
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			animateProgress()
		}
	}
}
