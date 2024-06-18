// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum NavigationBackButtonStyle {
	case registration, mainContainer
}

struct NavigationBackButtonModifier: ViewModifier {
	let style: NavigationBackButtonStyle

	func body(content: Content) -> some View {
		content
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: RegistrationBackButton(style: style))
	}
}
