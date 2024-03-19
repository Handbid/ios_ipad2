// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

@main
struct HandbidiPadAppHandbid: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject var registrationCoordinator = Coordinator<RegistrationPage, Any?>()

	var body: some Scene {
		WindowGroup {
			EnvironmentStartupView()
				.environmentObject(registrationCoordinator)
		}
	}
}

struct EnvironmentStartupView: View {
	var body: some View {
		ZStack {
			RootPageView<RegistrationPage>()
		}
	}
}
