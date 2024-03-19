// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

@main
struct HandbidiPadApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var registrationCoordinator = Coordinator<RegistrationPage, Any?> { page in
		switch page {
		case .getStarted:
			AnyView(GetStartedView<RegistrationPage>())
		case .logIn:
			AnyView(LogInView<RegistrationPage>())
		}
	}

	var body: some Scene {
		WindowGroup {
			EnvironmentStartupView()
				.environmentObject(registrationCoordinator)
		}
	}
}
