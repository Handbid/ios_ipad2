// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

@main
struct MainAppCoordinator: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var registrationCoordinator = Coordinator<RegistrationPage, Any?> { page in
		switch page {
		case .getStarted:
			AnyView(GetStartedView<RegistrationPage>(
				viewModel: GetStartedViewModel(repository:
					RegisterRepositoryImpl(
						NetworkingClient()
					))))
		case .logIn:
			AnyView(LogInView<RegistrationPage>(
				viewModel: LogInViewModel(repository: RegisterRepositoryImpl(NetworkingClient()),
				                          authManager: AuthManager())))
		case .chooseEnvironment:
			AnyView(ChooseEnvironmentView<RegistrationPage>(
				viewModel: ChooseEnvironmentViewModel()
			))
		case .forgotPassword:
			AnyView(ForgotPasswordView<RegistrationPage>(
				viewModel: ForgotPasswordViewModel(repository: ResetPasswordRepositoryImpl(
					NetworkingClient()
				))))
		case .resetPasswordConfirmation:
			AnyView(PasswordResetConfirmationView<RegistrationPage>())
		}
	}

	@StateObject var mainContainerCoordinator = Coordinator<MainContainerPage, Any?> { page in
		switch page {
		case .chooseOrganization:
			AnyView(ChooseOrganizationView<MainContainerPage>(viewModel: ChooseOrganizationViewModel()))
		case .chooseAuction:
			AnyView(ChooseAuctionView<MainContainerPage>(viewModel: ChooseAuctionViewModel(), selectedView: .selectAuction))
		case .mainContainer:
			AnyView(MainContainer<MainContainerPage>(selectedView: .auction))
		}
	}

	var body: some Scene {
		WindowGroup {
			AppLaunchControlView()
				.environmentObject(AuthManagerMainActor())
				.environmentObject(registrationCoordinator)
				.environmentObject(mainContainerCoordinator)
		}
	}
}
