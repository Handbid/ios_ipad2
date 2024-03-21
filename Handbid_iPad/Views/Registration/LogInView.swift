// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?

	var body: some View {
		Text("Hello, World2!")
			.accessibilityIdentifier("HelloWorld2TextView")
		Button("next") {
			coordinator.push(RegistrationPage.getStarted as! T)
		}
		.accessibilityIdentifier("nextButton")
		Button("back 1") {
			coordinator.pop()
		}
		.accessibilityIdentifier("back1Button")
		Button("back 2") {
			coordinator.popToRoot()
		}
		.accessibilityIdentifier("back2Button")
	}
}
