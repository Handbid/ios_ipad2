// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import SwiftUI

@main
struct MainAppCoordinator: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var registrationCoordinator: Coordinator<RegistrationPage, Any?>
	@StateObject var mainContainerCoordinator: Coordinator<MainContainerPage, Any?>

	init() {
		let deps = DependencyMainAppProvider.shared
		_registrationCoordinator = StateObject(wrappedValue: Coordinator<RegistrationPage, Any?> { page in
			switch page {
			case .getStarted:
				let repository = RegisterRepositoryImpl(deps.networkClient)
				let viewModel = GetStartedViewModel(repository: repository)
				return AnyView(GetStartedView<RegistrationPage>(viewModel: viewModel))
			case .logIn:
				let repository = RegisterRepositoryImpl(deps.networkClient)
				let viewModel = LogInViewModel(repository: repository, authManager: deps.authManager)
				return AnyView(LogInView<RegistrationPage>(viewModel: viewModel))
			case .chooseEnvironment:
				return AnyView(ChooseEnvironmentView<RegistrationPage>(viewModel: ChooseEnvironmentViewModel(deps.networkClient)))
			case .forgotPassword:
				let repository = ResetPasswordRepositoryImpl(deps.networkClient)
				let viewModel = ForgotPasswordViewModel(repository: repository)
				return AnyView(ForgotPasswordView<RegistrationPage>(viewModel: viewModel))
			case .resetPasswordConfirmation:
				return AnyView(PasswordResetConfirmationView<RegistrationPage>())
			}
		})

		_mainContainerCoordinator = StateObject(wrappedValue: Coordinator<MainContainerPage, Any?> { page in
			switch page {
			case .chooseOrganization:
				let repository = ChooseOrganizationRepositoryImpl(deps.networkClient)
				let viewModel = ChooseOrganizationViewModel(repository: repository)
				return AnyView(ChooseOrganizationView<MainContainerPage>(viewModel: viewModel))
			case .chooseAuction:
				let repository = ChooseAuctionRepositoryImpl(deps.networkClient)
				let viewModel = ChooseAuctionViewModel(repository: repository)
				return AnyView(ChooseAuctionView<MainContainerPage>(viewModel: viewModel, selectedView: .selectAuction))
			case .mainContainer:
				return AnyView(MainContainer<MainContainerPage>(selectedView: .auction))
			}
		})
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
