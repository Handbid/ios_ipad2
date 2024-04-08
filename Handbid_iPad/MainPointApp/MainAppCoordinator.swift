// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

@main
struct MainAppCoordinator: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var registrationCoordinator = Coordinator<RegistrationPage, Any?> { page in
		switch page {
		case .getStarted:
			AnyView(GetStartedView<RegistrationPage>())
		case .logIn:
			AnyView(LogInView<RegistrationPage>())
		case .chooseEnvironment:
			AnyView(ChooseEnvironmentView<RegistrationPage>())
		case .forgotPassword:
			AnyView(ForgotPasswordView<RegistrationPage>())
		case .resetPasswordConfirmation:
			AnyView(PasswordResetConfirmationView<RegistrationPage>())
		}
	}

	var body: some Scene {
		WindowGroup {
			AppLaunchControlView()
				.environmentObject(AuthManagerMainActor())
				.environmentObject(registrationCoordinator)
		}
	}
}
