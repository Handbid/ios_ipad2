// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class ItemDetailState: ObservableObject {
	@Published var selectedImage: String?
	@Published var remainingTime: Int = 60
	@Published var progress: CGFloat = 1.0
	private var timer: Timer?

	func startTimer() {
		stopTimer()
		progress = 1.0
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
			guard let self else { return }
			if remainingTime > 0 {
				remainingTime -= 1
				progress = CGFloat(remainingTime) / 60.0
			}
			else {
				stopTimer()
			}
		}
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	func reset() {
		stopTimer()
		selectedImage = nil
		remainingTime = 60
		progress = 1.0
	}

	func resetTimer() {
		remainingTime = 60
		progress = 1.0
	}
}
