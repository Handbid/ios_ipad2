// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class AlertManager: ObservableObject {
	static let shared = AlertManager()

	@Published var alertStack: [AnyView] = []
	var backgroundColor: Color = .black.opacity(0.4)

	private init() {}

	func showAlert(_ alert: some View, backgroundColor: Color = Color.black.opacity(0.4)) {
		self.backgroundColor = backgroundColor
		DispatchQueue.main.async {
			self.alertStack.append(AnyView(alert))
		}
	}

	func dismissAlert() {
		DispatchQueue.main.async {
			_ = self.alertStack.popLast()
		}
	}
}
