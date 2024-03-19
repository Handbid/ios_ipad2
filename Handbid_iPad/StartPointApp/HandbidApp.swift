// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct HandbidApp: View {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject var registrationCoordinator = Coordinator<RegistrationPage, Any?> { page in
		switch page {
		case .getStarted:
			AnyView(GetStartedView<RegistrationPage>())
		case .logIn:
			AnyView(LogInView<RegistrationPage>())
		}
	}

	var body: some View {
		EnvironmentStartupView()
			.environmentObject(registrationCoordinator)
	}
}

@main
struct HandbidAppLauncher: App {
	var body: some Scene {
		WindowGroup {
			HandbidApp()
		}
	}
}
