// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		Text("Hello, World2!")
		Button("next") {
			coordinator.push(RegistrationPage.getStarted as! T)
		}
		Button("back 1") {
			coordinator.pop()
		}
		Button("back 2") {
			coordinator.popToRoot()
		}
	}
}
