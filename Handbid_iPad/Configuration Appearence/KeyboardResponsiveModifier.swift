// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
	@State private var offset: CGFloat = 0
	@FocusState var isFocused: Bool

	func body(content: Content) -> some View {
		content
			.offset(y: -offset)
			.onTapGesture {
				if isFocused {
					isFocused = false
				}
			}
			.focused($isFocused, equals: true)
			.onAppear {
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
					let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
					let height = value.height
					offset = height / 6
				}
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
					offset = 0
				}
			}
			.onDisappear {
				NotificationCenter.default.removeObserver(self)
			}
	}
}
