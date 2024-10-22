// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
	@State private var padding: CGFloat = 0

	func body(content: Content) -> some View {
		content
			.padding(.bottom, padding)
			.onAppear {
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
					let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
					let height = value.height
					padding = height
				}
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
					padding = 0
				}
			}
			.onDisappear {
				NotificationCenter.default.removeObserver(self)
			}
	}
}
