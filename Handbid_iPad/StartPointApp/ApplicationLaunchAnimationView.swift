// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import ProgressIndicatorView
import SwiftUI

struct ApplicationLaunchAnimationView: View {
	@State private var showProgressIndicator: Bool = true
	@State private var progress: CGFloat = 0.0
	@State private var enableAutoProgress: Bool = true
	@State private var progressForDefaultSector: CGFloat = 0.0

	private let timer = Timer.publish(every: 1 / 5, on: .main, in: .common).autoconnect()
	@State private var textOffset: CGFloat = 0.0

	var body: some View {
		GeometryReader { geometry in
			let size = geometry.size.width / 5

			VStack {
				Spacer()

				Text("Handbid")
					.font(.system(size: 60))
					.fontWeight(.bold)
					.foregroundColor(.accentViolet)
					.offset(y: textOffset)
					.animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: textOffset)
					.transition(.move(edge: .top))
					.onAppear {
						textOffset = -size / 2
					}

				ProgressIndicatorView(isVisible: $showProgressIndicator, type: .impulseBar(progress: $progress, backgroundColor: .gray.opacity(0.25)))
					.frame(height: 8.0)
					.foregroundColor(.accentViolet)
					.padding([.bottom, .horizontal], size)

				Spacer()
			}
		}
		.onReceive(timer) { _ in
			guard enableAutoProgress else { return }
			switch progress {
			case ...0.3, 0.4 ... 0.6:
				progress += 1 / 30
			case 0.3 ... 0.4, 0.6 ... 0.9:
				progress += 1 / 120
			case 0.9 ... 0.99:
				progress = 1
			case 1.0...:
				progress = 0
			default:
				break
			}

			if progressForDefaultSector >= 1.5 {
				progressForDefaultSector = 0
			}
			else {
				progressForDefaultSector += 1 / 10
			}
		}
	}
}
